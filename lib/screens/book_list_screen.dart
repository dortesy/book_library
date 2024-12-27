import 'package:flutter/material.dart';
import 'package:superpuperproject/widgets/book_card.dart';
import '../models/book.dart';
import '../services/open_library_service.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final OpenLibraryService _openLibraryService = OpenLibraryService();
  List<Book> books = [];
  bool isLoading = false;
  String errorMessage = '';

  final searchController = TextEditingController();

  Future<void> searchBooks(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final results = await _openLibraryService.searchBooks(query);
      setState(() {
        books = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка при поиске книг. Пожалуйста, попробуйте снова.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Библиотека'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Поиск книг...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      books.clear();
                    });
                  },
                ),
              ),
              onSubmitted: (value) => searchBooks(value),
            ),
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty)
            Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          else
            Expanded(
              child: books.isEmpty
                ? Center(child: Text('Начните поиск книг'))
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return BookCard(book: books[index]);
                    },
                  ),
            ),
        ],
      ),
    );
  }
}
