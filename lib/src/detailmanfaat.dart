import 'package:flutter/material.dart';
import 'package:persiapanfit/utils/dbhelper.dart';

class DetailManfaat extends StatelessWidget {
  final int exerciseId;

  DetailManfaat({required this.exerciseId});

  // Fungsi untuk mengambil detail latihan berdasarkan ID
  Future<Map<String, dynamic>> _fetchExerciseDetail(int id) async {
    try {
      final data = await DatabaseHelper().fetchExerciseById(id); // Ambil data berdasarkan ID
      return data.isNotEmpty ? data[0] : {};
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Manfaat'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchExerciseDetail(exerciseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final exercise = snapshot.data!;
          
          // Ambil URL gambar atau nama gambar dari data
          String imageUrl = exercise['image'] ?? 'assets/placeholder.png';

          return Padding(
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
                      image: imageUrl.startsWith('http')
                          ? NetworkImage(imageUrl) // Jika URL gambar eksternal
                          : AssetImage(imageUrl) as ImageProvider, // Jika gambar lokal
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 16),
                // Menampilkan judul
                Text(
                  exercise['title'] ?? 'No title',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Menampilkan deskripsi
                Text(
                  exercise['description'] ?? 'No description',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
