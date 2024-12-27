// lib/services/google_books_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1';
  
  Future<Map<String, dynamic>?> findBookPreview(String title, String author) async {
    try {
      // Search for the exact book using title and author
      final query = Uri.encodeComponent('intitle:$title inauthor:$author');
      final url = Uri.parse('$baseUrl/volumes?q=$query');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>?;
        
        if (items != null && items.isNotEmpty) {
          final bookData = items[0];
          final volumeInfo = bookData['volumeInfo'];
          final accessInfo = bookData['accessInfo'];
          
          return {
            'id': bookData['id'],
            'previewLink': volumeInfo['previewLink'],
            'webReaderLink': accessInfo['webReaderLink'],
            'accessViewStatus': accessInfo['accessViewStatus'],
            'isPreviewAvailable': accessInfo['accessViewStatus'] != 'NONE',
            'sampleUrl': accessInfo['epub']?['acsTokenLink'] ?? accessInfo['pdf']?['acsTokenLink'],
            'title': volumeInfo['title'],
            'description': volumeInfo['description'] ?? '',
            'pageCount': volumeInfo['pageCount'] ?? 0,
          };
        }
      }
      return null;
    } catch (e) {
      print('Error fetching Google Books preview: $e');
      return null;
    }
  }

  String? getPreviewUrl(Map<String, dynamic> bookData) {
    if (bookData['isPreviewAvailable'] == true) {
      return bookData['previewLink'] ?? bookData['webReaderLink'];
    }
    return null;
  }
}