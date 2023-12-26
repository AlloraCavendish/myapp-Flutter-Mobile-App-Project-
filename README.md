# Firebase Flutter CRUD implementation

ICT602 - Mobile Technology and Development

This flutter app demonstrate a very simple bookstore app with the four basic operations (create, read, update, and delete) of data storage, regarded collectively.

# Features

1. Add new books including author
2. Admin and basic user roles
3. Edit book entries
4. View book menu

# CRUD Operations

CREATE

```dart
class AddBookScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _addBook(BuildContext context) {
    FirebaseFirestore.instance.collection('books').add({
      'title': _titleController.text,
      'author': _authorController.text,
      // Add more fields as needed
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
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
              onPressed: () => _addBook(context),
              child: Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}
```

READ

```dart
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
```

UPDATE

```dart
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

```

DELETE

```dart
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
          ],
        ),
      ),
    );
  }
}
```
