import 'package:flutter/material.dart';

import 'timer/view/timer_page.dart';

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter timer',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
        primary: Color.fromRGBO(72, 74, 126, 1),
      )),
      home: const TimerPage(),
    );
  }
}
