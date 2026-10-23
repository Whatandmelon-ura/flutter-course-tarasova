import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/book.dart';
import '../widgets/book_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<String> _likedIds = {};
  bool _onlyFavorites = false;
  bool _showForm = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  // Ссылка на коллекцию в Firebase
  final Stream<QuerySnapshot<Map<String, dynamic>>> _booksStream =
    FirebaseFirestore.instance.collection('books').snapshots();

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _addBook() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final newBook = Book(
      title: title,
      subtitle: _subtitleController.text.trim().isEmpty
          ? 'Без автора'
          : _subtitleController.text.trim(),
      category: BookCategory.novel,
      description: 'Добавлено из приложения',
    );

    try {
      // Отправляем в Firebase!
      await FirebaseFirestore.instance.collection('books').add(newBook.toJson());
      
      setState(() {
        _showForm = false;
        _titleController.clear();
        _subtitleController.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Книга добавлена в Firebase!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  void _toggleLike(String? id) {
    if (id == null) return;
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

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.deepPurple.shade50,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Автор',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _addBook,
            icon: const Icon(Icons.save),
            label: const Text('Отправить в Firebase'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Кнопка добавления формы
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('Избр.: ${_likedIds.length}'),
            ),
          ),
          // КНОПКА ВЫХОДА
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showForm) _buildForm(),
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _booksStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final docs = snapshot.data!.docs;
                final books = docs.map((doc) => Book.fromFirestore(doc)).toList();
                
                final visibleBooks = _onlyFavorites
                    ? books.where((b) => _likedIds.contains(b.id)).toList()
                    : books;

                if (visibleBooks.isEmpty) {
                  return const Center(child: Text('Ничего не нашлось. Добавьте книгу!'));
                }

                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}