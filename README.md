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
'''
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
'''
