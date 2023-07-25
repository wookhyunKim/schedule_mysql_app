import 'package:flutter/material.dart';

class Dpage extends StatelessWidget {
  final String rcode;
  final String rtitle;
  final String rcontent;
  final String rdate;

  const Dpage(
      {super.key,
      required this.rcode,
      required this.rtitle,
      required this.rcontent,
      required this.rdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diatry Note'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.apple_sharp),
              Text(
                'My $rcode st diary',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                rtitle,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'diary Content',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple), // 내용 글씨 색상 변경
              ),
              const SizedBox(height: 8),
              Text(
                rcontent,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 100),
              Text(
                '작성일: $rdate',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
