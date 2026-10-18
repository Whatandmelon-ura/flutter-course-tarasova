enum BookCategory {
  novel,
  classic,
  fantasy,
  scifi,
  detective,
  history,
}

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.description,
  });

  final int id;
  final String title;
  final String subtitle;
  final BookCategory category;
  final String? description;

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