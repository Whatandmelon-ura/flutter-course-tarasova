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

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString(),
      title: json['title'] ?? 'Без названия',
      subtitle: json['subtitle'] ?? '',
      category: BookCategory.values.byName(json['category'] ?? 'novel'),
      description: json['description'] ?? '',
    );
  }

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
      case BookCategory.novel:
        return 'Роман';
      case BookCategory.classic:
        return 'Классика';
      case BookCategory.fantasy:
        return 'Фэнтези';
      case BookCategory.scifi:
        return 'Фантастика';
      case BookCategory.detective:
        return 'Детектив';
      case BookCategory.history:
        return 'История';
    }
  }

  @override
  String toString() => 'Book($id, $title)';
}