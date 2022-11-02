import 'package:flutter/material.dart';
import 'package:unlimited_canvas_plan2/page/white_board_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WhiteBoardPage(),
    );
  }
}
