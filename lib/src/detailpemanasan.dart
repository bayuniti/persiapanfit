import 'package:flutter/material.dart';
import 'package:persiapanfit/utils/dbhelper.dart';

class DetailPage extends StatefulWidget {
  final int id;

  DetailPage({required this.id, required exerciseId}); // Menerima id dari halaman sebelumnya

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan gambar
            Container(
              width: double.infinity,
              height: 200, // Tentukan tinggi gambar
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: exerciseDetail?['image'] != null && exerciseDetail!['image'].startsWith('http')
                      ? NetworkImage(exerciseDetail!['image'])
                      : AssetImage(exerciseDetail!['image']) as ImageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 16),
            // Menampilkan judul
            Text(
              exerciseDetail?['title'] ?? 'No title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Menampilkan deskripsi
            Text(
              exerciseDetail?['description'] ?? 'No description',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
