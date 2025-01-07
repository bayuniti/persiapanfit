import 'package:flutter/material.dart';
import 'package:persiapanfit/src/detailpemanasan.dart';
import 'package:persiapanfit/utils/dbhelper.dart';

class MyPemanasan extends StatefulWidget {
  @override
  _MyPemanasanState createState() => _MyPemanasanState();
}

class _MyPemanasanState extends State<MyPemanasan> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> warmUpExercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final data = await _dbHelper.fetchExercises();
    setState(() {
      warmUpExercises = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemanasan Sebelum Olahraga"),
      ),
      body: warmUpExercises.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: warmUpExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = warmUpExercises[index];

                      // Mendefinisikan shortDescription
                      String description = exercise['description'] ?? 'No description';
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
                                builder: (context) =>
                                    DetailPage(id: exercise['id'], exerciseId: null,),
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
                ),
              ],
            ),
    );
  }
}
