// lib/models/book.dart
class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String publishDate;
  final int pages;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description = '',
    required this.coverUrl,
    this.publishDate = '',
    this.pages = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'publishDate': publishDate,
      'pages': pages,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      publishDate: map['publishDate'] ?? '',
      pages: map['pages']?.toInt() ?? 0,
    );
  }

  factory Book.fromOpenLibrary(Map<String, dynamic> json) {
    final id = json['key']?.toString().replaceAll('/works/', '') ?? '';
    final title = json['title'] ?? 'Unknown Title';
    final author = json['author_name']?.first ?? 'Unknown Author';
    final description = json['description'] ?? '';
    final coverUrl = json['cover_i'] != null 
        ? 'https://covers.openlibrary.org/b/id/${json["cover_i"]}-L.jpg'
        : '';
    final publishDate = json['first_publish_year']?.toString() ?? '';
    final pages = json['number_of_pages_median']?.toInt() ?? 0;

    return Book(
      id: id,
      title: title,
      author: author,
      description: description,
      coverUrl: coverUrl,
      publishDate: publishDate,
      pages: pages,
    );
  }
}