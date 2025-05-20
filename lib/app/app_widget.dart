import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';
import 'package:hackathon_vegas/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin Lockers',
      theme: BitcoinLockerTheme.themeData,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}