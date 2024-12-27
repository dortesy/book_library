// lib/screens/saved_books_screen.dart
import 'package:flutter/material.dart';
import 'package:superpuperproject/models/book.dart';
import 'package:superpuperproject/services/book_service.dart';
import 'package:superpuperproject/widgets/book_card.dart';

class SavedBooksScreen extends StatelessWidget {
  final BookService _bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Моя библиотека'),
      ),
      body: StreamBuilder<List<Book>>(
        stream: _bookService.getSavedBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки книг: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Нет сохраненных книг',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text('Искать книги'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(book: books[index]);
            },
          );
        },
      ),
    );
  }
}