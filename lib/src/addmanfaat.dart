import 'package:flutter/material.dart';
import 'package:persiapanfit/utils/dbhelper.dart';

class ManageNewExercises extends StatefulWidget {
  @override
  _ManageNewExercisesState createState() => _ManageNewExercisesState();
}

class _ManageNewExercisesState extends State<ManageNewExercises> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  List<Map<String, dynamic>> _newExercises = [];

  @override
  void initState() {
    super.initState();
    _loadNewExercises();
  }

  Future<void> _loadNewExercises() async {
    final exercises = await _dbHelper.getAllNewExercises();
    setState(() {
      _newExercises = exercises;
    });
  }

  Future<void> _addOrUpdateExercise({Map<String, dynamic>? exercise}) async {
    if (exercise != null) {
      _titleController.text = exercise['title'];
      _descriptionController.text = exercise['description'];
      _imageController.text = exercise['image'];
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(exercise == null ? 'Tambah Data' : 'Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Path Gambar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newExercise = {
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'image': _imageController.text,
                };
                if (exercise == null) {
                  await _dbHelper.insertNewExercise(newExercise);
                } else {
                  await _dbHelper.updateNewExercise(exercise['id'], newExercise);
                }
                Navigator.of(context).pop();
                _loadNewExercises();
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );

    _titleController.clear();
    _descriptionController.clear();
    _imageController.clear();
  }

  Future<void> _deleteExercise(int id) async {
    await _dbHelper.deleteNewExercise(id);
    _loadNewExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Manfaat'),
      ),
      body: ListView.builder(
        itemCount: _newExercises.length,
        itemBuilder: (context, index) {
          final exercise = _newExercises[index];
          return ListTile(
            title: Text(exercise['title']),
            subtitle: Text(exercise['description']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _addOrUpdateExercise(exercise: exercise);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteExercise(exercise['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrUpdateExercise();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
