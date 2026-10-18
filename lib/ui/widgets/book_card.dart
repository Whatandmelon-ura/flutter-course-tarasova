import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.isLiked,
    required this.onLikeTap,
  });

  final Book book;
  final bool isLiked;
  final VoidCallback onLikeTap;

  IconData _iconForCategory(BookCategory c) {
    switch (c) {
      case BookCategory.novel:
        return Icons.menu_book;
      case BookCategory.classic:
        return Icons.auto_stories;
      case BookCategory.fantasy:
        return Icons.auto_awesome;
      case BookCategory.scifi:
        return Icons.rocket_launch;
      case BookCategory.detective:
        return Icons.search;
      case BookCategory.history:
        return Icons.history_edu;
    }
  }

  Color _colorForCategory(BookCategory c) {
    switch (c) {
      case BookCategory.novel:
        return const Color(0xFF8E24AA);
      case BookCategory.classic:
        return const Color(0xFF3949AB);
      case BookCategory.fantasy:
        return const Color(0xFF6D4C41);
      case BookCategory.scifi:
        return const Color(0xFF00897B);
      case BookCategory.detective:
        return const Color(0xFF546E7A);
      case BookCategory.history:
        return const Color(0xFFE53935);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _colorForCategory(book.category),
                        _colorForCategory(book.category).withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Center(
                  child: Icon(
                    _iconForCategory(book.category),
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onLikeTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
                  book.subtitle,
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
                    Icon(
                      Icons.category,
                      size: 14,
                      color: Colors.deepPurple[300],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      book.categoryLabel,
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