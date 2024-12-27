import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:superpuperproject/models/book.dart';
import 'package:superpuperproject/services/book_service.dart';
import 'package:superpuperproject/services/open_library_service.dart';
import 'package:superpuperproject/services/google_books_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final OpenLibraryService _openLibraryService = OpenLibraryService();
  final BookService _bookService = BookService();
  final GoogleBooksService _googleBooksService = GoogleBooksService();
  
  String fullDescription = '';
  bool isLoading = true;
  bool isSaved = false;
  bool isSaving = false;
  Map<String, dynamic>? previewData;
  bool isLoadingPreview = true;

  @override
  void initState() {
    super.initState();
    _loadBookDetails();
    _checkIfBookSaved();
    _loadPreviewData();
  }

  Future<void> _loadPreviewData() async {
    try {
      final data = await _googleBooksService.findBookPreview(
        widget.book.title, 
        widget.book.author
      );
      setState(() {
        previewData = data;
        isLoadingPreview = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPreview = false;
      });
    }
  }

  Future<void> _openPreview() async {
    final previewUrl = _googleBooksService.getPreviewUrl(previewData!);
    if (previewUrl != null) {
      final uri = Uri.parse(previewUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open preview')),
        );
      }
    }
  }

  Future<void> _loadBookDetails() async {
    try {
      final details = await _openLibraryService.getBookDetails(widget.book.id);
      setState(() {
        fullDescription = details['description'] is String 
          ? details['description'] 
          : details['description']?['value'] ?? widget.book.description;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        fullDescription = widget.book.description;
        isLoading = false;
      });
    }
  }

  Future<void> _checkIfBookSaved() async {
    final saved = await _bookService.isBookSaved(widget.book.id);
    setState(() {
      isSaved = saved;
    });
  }

  Future<void> _toggleSaveBook() async {
    setState(() {
      isSaving = true;
    });

    try {
      if (isSaved) {
        await _bookService.removeBook(widget.book.id);
      } else {
        await _bookService.saveBook(widget.book);
      }
      setState(() {
        isSaved = !isSaved;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.red : null,
            ),
            onPressed: isSaving ? null : _toggleSaveBook,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLoadingPreview && previewData != null && previewData!['isPreviewAvailable'] == true)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _openPreview,
                    icon: Icon(Icons.book),
                    label: Text('Read Preview'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
              ),
            
            // Preview Status
            if (isLoadingPreview)
              Center(child: CircularProgressIndicator())
            else if (previewData == null || previewData!['isPreviewAvailable'] == false)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Preview not available',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.book.coverUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.author,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 172, 76, 76),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.book.publishDate.isNotEmpty) ...[
                    Text(
                      'Published: ${widget.book.publishDate}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (widget.book.pages > 0) ...[
                    Text(
                      'Pages: ${widget.book.pages}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Text(
                      fullDescription.isNotEmpty 
                        ? fullDescription 
                        : 'No description available.',
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}