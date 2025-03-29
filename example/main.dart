import 'package:flutter/material.dart';
import 'package:helix_indicator/helix_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Her OS Loader',
      theme: ThemeData.dark(),
      home: const Scaffold(
        backgroundColor: Color(0xffd1684e),
        body: Center(
          child: HelixIndicator(color: Colors.white, size: 150),
        ),
      ),
    );
  }
}
