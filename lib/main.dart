import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng dự báo thời tiết',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2898EE),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFBFBFC),
      ),
      home: const HomeScreen(),
    );
  }
}
