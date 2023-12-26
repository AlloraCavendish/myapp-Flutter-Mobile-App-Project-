// edit_book_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookScreen extends StatefulWidget {
  final String documentId;
  final String title;
  final String author;

  EditBookScreen(
      {required this.documentId, required this.title, required this.author});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _authorController = TextEditingController(text: widget.author);
  }

  void _updateBook() {
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.documentId)
        .update({
      'title': _titleController.text,
      'author': _authorController.text,
      // Add more fields as needed
    }).then((_) {
      print('Book updated successfully');
      Navigator.pop(context); // Return to the previous screen after updating
    }).catchError((error) {
      print('Error updating book: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Book Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBook,
              child: Text('Update Book'),
            ),
          ],
        ),
      ),
    );
  }
}
