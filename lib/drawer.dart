import 'package:flutter/material.dart';
import 'package:persiapanfit/src/inputdata.dart';
import 'package:persiapanfit/src/pemanasan.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  image: const DecorationImage(
                      image: AssetImage('assets/images/persiapan.jpeg'),
                      fit: BoxFit.cover)),
              child: Container()),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text('Pemanasan'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPemanasan()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.thumb_up),
            title: const Text('Manfaat'),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InputData()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Beri Penilaian'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Info Aplikasi'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Tutup'))
                      ],
                      contentPadding: const EdgeInsets.all(20.0),
                      content: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(children: [
                            TextSpan(
                                text: 'Versi \n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text: '1.0.0 \n',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text: '\n Pengembang \n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text: 'Bayu Niti Kurniawan \n',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ]))));
            },
          ),
        ],
      ),
    );
  }
}
