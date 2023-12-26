import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewBookScreen extends StatelessWidget {
  final String title;
  final String author;
  final String userEmail; // User's email address

  ViewBookScreen({
    required this.title,
    required this.author,
    required this.userEmail,
  });

  // Function to check if the user is an administrator
  bool get isAdmin => userEmail == 'admin@gmail.com';

  // Function to handle the delete action
  Future<void> _onDelete(BuildContext context) async {
    await _onDeleteLogic(context, isAdmin);
  }

  // Function to handle app-only delete logic for normal users
  Future<void> _onAppDelete(BuildContext context) async {
    await _onDeleteLogic(context, false);
  }

  Future<void> _onDeleteLogic(BuildContext context, bool isAdmin) async {
    try {
      if (isAdmin) {
        // For administrators: Delete data from both app and Firebase
        await FirestoreService().deleteBook(title);
        print('Deleting data from both app and Firebase...');
        print('Delete completed.');
        Navigator.pop(context);
      } else {
        print('Simulating delete within the app...');

        Navigator.pop(context);

        await Future.delayed(Duration(milliseconds: 200));

        Navigator.pop(context);
      }
    } catch (error) {
      print('Error during deletion: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Book'),
                  content: Text('Are you sure you want to delete this book?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _onDelete(context);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title'),
            SizedBox(height: 10),
            Text('Author: $author'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

class FirestoreService {
  Future<void> deleteBook(String title) async {
    try {
      // Query Firestore to find the document with the specified title
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('title', isEqualTo: title)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first document found (you might want to refine this logic)
        await querySnapshot.docs.first.reference.delete();
        print('Document deleted successfully.');
      } else {
        print('No matching document found for deletion.');
      }
    } catch (error) {
      print('Error deleting document: $error');
    }
  }
}
