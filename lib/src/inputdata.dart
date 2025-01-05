import 'package:flutter/material.dart';
import 'package:persiapanfit/utils/dbhelper.dart';

class InputData extends StatefulWidget {
  @override
  _InputDataState createState() => _InputDataState();
}
class _InputDataState extends State<InputData> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk form utama
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exercises = await _dbHelper.getAllExercises();
    setState(() {
      _exercises = exercises;
    });
  }

  Future<void> _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      if (_titleController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _imageController.text.isNotEmpty) {
        await _dbHelper.insertExercise({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'image': _imageController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data berhasil disimpan!'),
            duration: const Duration(seconds: 2),
          ),
        );

        _clearForm();
        _loadExercises();
      }
    }
  }

  Future<void> _editExercise(Map<String, dynamic> exercise) async {
    _titleController.text = exercise['title'];
    _descriptionController.text = exercise['description'];
    _imageController.text = exercise['image'];

    // Gunakan GlobalKey yang baru untuk form edit
    final _editFormKey = GlobalKey<FormState>();

    // Tampilkan dialog untuk mengedit
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Exercise'),
          content: Form(
            key: _editFormKey, // Setiap form menggunakan GlobalKey yang unik
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Path Gambar'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Path gambar tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_editFormKey.currentState!.validate()) {
                  _dbHelper.updateExercise(exercise['id'], {
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'image': _imageController.text,
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil diubah!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      _loadExercises();
                    });
                    Navigator.of(context).pop();
                  }).catchError((e) {
                    print('Error updating exercise: $e');
                  });
                }
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
  }

  Future<void> _deleteExercise(int id) async {
    await _dbHelper.deleteExercise(id);
    _loadExercises();
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _imageController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Latihan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Judul'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(labelText: 'Path Gambar'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Path gambar tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveExercise,
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  final exercise = _exercises[index];
                  return Card(
                    child: ListTile(
                      title: Text(exercise['title']),
                      subtitle: Text(exercise['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editExercise(exercise);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteExercise(exercise['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
