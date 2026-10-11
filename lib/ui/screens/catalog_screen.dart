import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../widgets/book_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const List<Book> _books = [
    Book(
      id: 1,
      title: 'Мастер и Маргарита',
      subtitle: 'Михаил Булгаков · 1967',
      category: BookCategory.novel,
    ),
    Book(
      id: 2,
      title: 'Пикник на обочине',
      subtitle: 'Стругацкие · 1972',
      category: BookCategory.scifi,
    ),
    Book(
      id: 3,
      title: '1984',
      subtitle: 'Джордж Оруэлл · 1949',
      category: BookCategory.scifi,
    ),
    Book(
      id: 4,
      title: 'Маленький принц',
      subtitle: 'Антуан де Сент-Экзюпери · 1943',
      category: BookCategory.fantasy,
    ),
    Book(
      id: 5,
      title: 'Над пропастью во ржи',
      subtitle: 'Джером Сэлинджер · 1951',
      category: BookCategory.novel,
    ),
    Book(
      id: 6,
      title: 'Преступление и наказание',
      subtitle: 'Фёдор Достоевский · 1866',
      category: BookCategory.classic,
    ),
    Book(
      id: 7,
      title: 'Война и мир',
      subtitle: 'Лев Толстой · 1869',
      category: BookCategory.classic,
    ),
    Book(
      id: 8,
      title: 'Дюна',
      subtitle: 'Фрэнк Герберт · 1965',
      category: BookCategory.scifi,
    ),
    Book(
      id: 9,
      title: 'Убить пересмешника',
      subtitle: 'Харпер Ли · 1960',
      category: BookCategory.novel,
    ),
    Book(
      id: 10,
      title: 'Гарри Поттер и философский камень',
      subtitle: 'Дж. К. Роулинг · 1997',
      category: BookCategory.fantasy,
    ),
  ];

  final Set<int> _likedIds = {};
  bool _onlyFavorites = false;

  void _toggleLike(int id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  void _toggleFilter() {
    setState(() {
      _onlyFavorites = !_onlyFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleBooks = _onlyFavorites
        ? _books.where((b) => _likedIds.contains(b.id)).toList()
        : _books;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'В избранном: ${_likedIds.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.filter_alt, size: 20),
                const SizedBox(width: 8),
                const Expanded(child: Text('Только избранные')),
                Switch(
                  value: _onlyFavorites,
                  onChanged: (_) => _toggleFilter(),
                ),
              ],
            ),
          ),
          Expanded(
            child: visibleBooks.isEmpty
                ? const Center(child: Text('Ничего не нашлось'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: visibleBooks.length,
                    itemBuilder: (context, index) {
                      final book = visibleBooks[index];
                      return BookCard(
                        book: book,
                        isLiked: _likedIds.contains(book.id),
                        onLikeTap: () => _toggleLike(book.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}