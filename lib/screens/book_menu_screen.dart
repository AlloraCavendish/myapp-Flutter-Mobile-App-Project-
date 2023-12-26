// book_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'edit_book_screen.dart';
import 'view_book_screen.dart';

class BookMenuScreen extends StatelessWidget {
  // Function to get the current user's email address
  Future<String?> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Menu Screen'),
      ),
      body: FutureBuilder(
        future: _getUserEmail(),
        builder: (context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return BookList(userEmail: snapshot.data);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addBook');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  final String? userEmail;

  BookList({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        var books = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            var book = books[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(book['title'] ?? 'No Title'),
              subtitle: Text(book['author'] ?? 'No Author'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      // Navigate to the ViewBookScreen with the current book details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewBookScreen(
                            title: book['title'] ?? '',
                            author: book['author'] ?? '',
                            userEmail: userEmail ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to the EditBookScreen with the document ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookScreen(
                            documentId: books[index].id,
                            title: book['title'] ?? '',
                            author: book['author'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
