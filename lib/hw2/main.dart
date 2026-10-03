import 'package:flutter/material.dart';

void main() {
  runApp(const Hw2App());
}

class Hw2App extends StatelessWidget {
  const Hw2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Каталог книг',
      theme: ThemeData(useMaterial3: true),
      home: const CatalogScreen(),
    );
  }
}

// Модель одной книги
class Book {
  final String title;
  final String author;
  final IconData icon;
  final Color color;
  const Book(this.title, this.author, this.icon, this.color);
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  // Список из 10 книг
  static const List<Book> books = [
    Book('Мастер и Маргарита', 'Михаил Булгаков', Icons.menu_book, Color(0xFF8E24AA)),
    Book('Преступление и наказание', 'Фёдор Достоевский', Icons.menu_book, Color(0xFF3949AB)),
    Book('Война и мир', 'Лев Толстой', Icons.menu_book, Color(0xFF00897B)),
    Book('1984', 'Джордж Оруэлл', Icons.visibility, Color(0xFF546E7A)),
    Book('Гарри Поттер и философский камень', 'Дж. К. Роулинг', Icons.auto_stories, Color(0xFF6D4C41)),
    Book('Убить пересмешника', 'Харпер Ли', Icons.menu_book, Color(0xFF43A047)),
    Book('Три товарища', 'Эрих Мария Ремарк', Icons.menu_book, Color(0xFFE53935)),
    Book('Маленький принц', 'Антуан де Сент-Экзюпери', Icons.auto_stories, Color(0xFFF9A825)),
    Book('Дюна', 'Фрэнк Герберт', Icons.public, Color(0xFFFB8C00)),
    Book('Цветы для Элджернона', 'Дэниел Киз', Icons.local_florist, Color(0xFF8D6E63)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // ОБЛОЖКА — Stack из трёх слоёв
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Слой 1: цветной фон с градиентом
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [book.color, book.color.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Слой 2: иконка по центру
                Center(
                  child: Icon(book.icon, color: Colors.white, size: 36),
                ),
                // Слой 3: лайк в правом верхнем углу
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ТЕКСТОВЫЙ БЛОК — занимает всё оставшееся место
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.category,
                        size: 14, color: Colors.deepPurple[300]),
                    const SizedBox(width: 4),
                    Text(
                      'Художественная литература',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple[300],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}