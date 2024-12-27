
// lib/services/open_library_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:superpuperproject/models/book.dart';

class OpenLibraryService {
  static const String baseUrl = 'https://openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse('$baseUrl/search.json?q=${Uri.encodeComponent(query)}');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List;
        return docs.where((doc) => doc['cover_i'] != null)
                  .map((doc) => Book.fromOpenLibrary(doc))
                  .toList();
      }
      throw Exception('Failed to load books');
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  Future<Map<String, dynamic>> getBookDetails(String workId) async {
    final url = Uri.parse('$baseUrl/works/$workId.json');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load book details');
    } catch (e) {
      throw Exception('Error getting book details: $e');
    }
  }
}
