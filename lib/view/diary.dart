import 'package:flutter/material.dart';

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : const Text('일기장')
      ),
    );
  }
}