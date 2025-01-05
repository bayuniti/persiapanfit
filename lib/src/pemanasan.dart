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
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset(
                            exercise['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(exercise['title']),
                          subtitle: Text(
                            exercise['description'],
                            maxLines: 2, // Batasi jumlah baris yang tampil
                            overflow: TextOverflow.ellipsis, // Tambahkan elipsis jika teks panjang
                          ),
                          onTap: () {
                            // Navigasi ke halaman detail dan pass id
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(id: exercise['id']),
                              ),
                            );
                          },
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
