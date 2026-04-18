import 'package:flutter/material.dart';

class FishdorroApp extends StatelessWidget {
  const FishdorroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fishdorro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fishdorro'),
      ),
      body: const Center(
        child: Text('Fishdorro — M0 scaffold'),
      ),
    );
  }
}
