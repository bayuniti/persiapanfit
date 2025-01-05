import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:persiapanfit/drawer.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analog Clock & Warm-up Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _currentTime = DateTime.now().toLocal();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
  }

  void _getCurrentTime() {
    setState(() {
      _currentTime = DateTime.now().toLocal(); // Menggunakan waktu lokal
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: AnalogClock(),
          ),
          const SizedBox(height: 20),
          // Teks yang menampilkan waktu saat ini
          Text(
            'Current Time: ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now().toLocal();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now().toLocal(); // Menggunakan waktu lokal
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: ClockPainter(_dateTime),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Background Circle
    final paintCircle = Paint()
      ..color = Colors.blue[100]!
      ..style = PaintingStyle.fill;

    // Border Circle
    final paintBorder = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Draw the clock background
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    // Draw hour, minute, and second hands
    final paintHourHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final paintMinuteHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final paintSecondHand = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final hourHandLength = radius * 0.5;
    final minuteHandLength = radius * 0.7;
    final secondHandLength = radius * 0.9;

    final hourAngle =
        ((dateTime.hour % 12) * 30 + dateTime.minute * 0.5) * pi / 180;
    final minuteAngle =
        (dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180;
    final secondAngle = dateTime.second * 6 * pi / 180;

    // Draw hour hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourHandLength * cos(hourAngle - pi / 2),
        center.dy + hourHandLength * sin(hourAngle - pi / 2),
      ),
      paintHourHand,
    );

    // Draw minute hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteHandLength * cos(minuteAngle - pi / 2),
        center.dy + minuteHandLength * sin(minuteAngle - pi / 2),
      ),
      paintMinuteHand,
    );

    // Draw second hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + secondHandLength * cos(secondAngle - pi / 2),
        center.dy + secondHandLength * sin(secondAngle - pi / 2),
      ),
      paintSecondHand,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
