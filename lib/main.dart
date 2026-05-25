// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/main_calendar_screen.dart'; // 메인 화면 불러오기

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A8A)),
        scaffoldBackgroundColor: const Color(0xFFFFF9F9),
        useMaterial3: true,
      ),
      home: const MainCalendarScreen(), // 첫 화면 지정
    );
  }
}
