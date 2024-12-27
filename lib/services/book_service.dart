// lib/services/book_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superpuperproject/models/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveBook(Book book) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_books')
          .doc(book.id)
          .set(book.toMap());
    } catch (e) {
      print('Error saving book: $e');
      throw Exception('Failed to save book. Please try again later.');
    }
  }

  Future<void> removeBook(String bookId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_books')
          .doc(bookId)
          .delete();
    } catch (e) {
      print('Error removing book: $e');
      throw Exception('Failed to remove book. Please try again later.');
    }
  }

  Future<bool> isBookSaved(String bookId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_books')
          .doc(bookId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking if book is saved: $e');
      return false;
    }
  }

  Stream<List<Book>> getSavedBooks() {
    try {
      final user = _auth.currentUser;
      if (user == null) return Stream.value([]);

      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_books')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList());
    } catch (e) {
      print('Error getting saved books: $e');
      return Stream.value([]);
    }
  }
}