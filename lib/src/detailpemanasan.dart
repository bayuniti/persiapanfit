import 'package:flutter/material.dart';
import 'package:persiapanfit/utils/dbhelper.dart';

class DetailPage extends StatefulWidget {
  final int id;

  DetailPage({required this.id}); // Menerima id dari halaman sebelumnya

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, dynamic>? exerciseDetail;

  @override
  void initState() {
    super.initState();
    _loadExerciseDetail();
  }

  Future<void> _loadExerciseDetail() async {
    final exercise = await _dbHelper.getExerciseById(widget.id);
    setState(() {
      exerciseDetail = exercise;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (exerciseDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Latihan'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Latihan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(exerciseDetail!['image'], fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              exerciseDetail!['title'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              exerciseDetail!['description'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
          
          ],
        ),
      ),
    );
  }
}
