import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/book.dart';
import '../widgets/book_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final String baseUrl = 'https://6ad4833648476c0785d90964.mockapi.io/books';
  
  List<Book> _books = [];
  final Set<String> _likedIds = {};
  bool _onlyFavorites = false;
  
  bool _isLoading = true;
  String? _error;
  bool _showForm = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode != 200) {
        throw Exception('Статус ${response.statusCode}');
      }
      final List<dynamic> decoded = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _books = decoded.map((e) => Book.fromJson(e)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      description: 'Добавлено пользователем',
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(newBook.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Статус ${response.statusCode}');
      }

      final created = Book.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        _books.insert(0, created);
        _showForm = false;
        _titleController.clear();
        _subtitleController.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Книга добавлена на сервер!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки: $e')),
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
                    labelText: 'Название (обязательно)',
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
                    labelText: 'Автор/Год',
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
            label: const Text('Отправить на сервер'),
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
    final visibleBooks = _onlyFavorites
        ? _books.where((b) => _likedIds.contains(b.id)).toList()
        : _books;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог книг'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('В избр.: ${_likedIds.length}'),
            ),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Ошибка: $_error'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadBooks,
                              child: const Text('Обновить'),
                            ),
                          ],
                        ),
                      )
                    : visibleBooks.isEmpty
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