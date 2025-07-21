import 'package:flutter/material.dart';

class JoinEmailScreen extends StatelessWidget {
  const JoinEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: const Center(
        child: Text(
          '회원가입 화면입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
} 