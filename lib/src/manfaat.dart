import 'package:flutter/material.dart';
import 'package:persiapanfit/src/detailmanfaat.dart';
import 'package:persiapanfit/utils/dbhelper.dart';


class MyManfaat extends StatefulWidget {
  @override
  _MyManfaatState createState() => _MyManfaatState();
}

class _MyManfaatState extends State<MyManfaat> {
  List<Map<String, dynamic>> _newExercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNewExercises();
  }

  // Fungsi untuk mengambil data dari tabel new_exercises
  Future<void> _fetchNewExercises() async {
    try {
      final data = await DatabaseHelper().fetchWarmupExercises();
      setState(() {
        _newExercises = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manfaat'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _newExercises.isEmpty
              ? Center(
                  child: Text('No data available'),
                )
              : ListView.builder(
                  itemCount: _newExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _newExercises[index];
                    String description = exercise['description'] ?? 'No description';
                    // Potong deskripsi jika terlalu panjang
                    String shortDescription = description.length > 100
                        ? description.substring(0, 100) + '...'
                        : description;

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          // Arahkan ke halaman detail berdasarkan ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailManfaat(exerciseId: exercise['id']),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menampilkan gambar
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: exercise['image'] != null &&
                                          exercise['image'].isNotEmpty
                                      ? (exercise['image'].startsWith('http')
                                              ? NetworkImage(exercise['image'])
                                              : AssetImage(exercise['image']))
                                          as ImageProvider
                                      : AssetImage('assets/placeholder.png')
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Menampilkan judul dan deskripsi singkat
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise['title'] ?? 'No title',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      shortDescription,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
