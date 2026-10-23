import 'package:cloud_firestore/cloud_firestore.dart';

enum BookCategory {
  novel,
  classic,
  fantasy,
  scifi,
  detective,
  history,
}

class Book {
  final String? id;
  final String title;
  final String subtitle;
  final BookCategory category;
  final String? description;

  const Book({
    this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.description,
  });

  // Этот метод превращает документ из Firebase в нашу модель
  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Book(
      id: doc.id,
      title: data['title'] ?? 'Без названия',
      subtitle: data['subtitle'] ?? '',
      category: BookCategory.values.byName(data['category'] ?? 'novel'),
      description: data['description'] ?? '',
    );
  }

  // Этот метод превращает модель в Map для отправки в Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'category': category.name,
      'description': description ?? '',
    };
  }

  String get categoryLabel {
    switch (category) {
      case BookCategory.novel: return 'Роман';
      case BookCategory.classic: return 'Классика';
      case BookCategory.fantasy: return 'Фэнтези';
      case BookCategory.scifi: return 'Фантастика';
      case BookCategory.detective: return 'Детектив';
      case BookCategory.history: return 'История';
    }
  }
}