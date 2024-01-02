import 'dart:async';

import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Duration _second = const Duration(hours: 0, minutes: 0, seconds: 1);
  Duration _duration = const Duration(hours: 0, minutes: 0);
  bool started = false, onGoing = false;
  late Timer resetTimer;

  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      resetTimer = timer;
      if (onGoing) {
        if (_duration.inSeconds > 0) {
          setState(() => _duration -= _second);
        } else {
          timer.cancel();
          setState(() => started = onGoing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Countdown finished!'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DurationPicker(
              duration: _duration,
              onChange: (val) => setState(() => _duration = val),
              snapToMins: 5.0,
            ),
            Text(
              _duration.toString().split('.')[0],
              style: const TextStyle(
                fontSize: 70,
              ),
            ),
            Column(
              children: [
                MaterialButton(
                  onPressed: () {
                    if (!started && _duration.inSeconds > 0) {
                      setState(() => started = onGoing = true);
                      _startCountDown();
                    }
                  },
                  color: Colors.deepPurple,
                  child: const Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                started
                    ? MaterialButton(
                        onPressed: () {
                          setState(() {
                            onGoing = !onGoing;
                          });
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          onGoing ? 'STOP' : 'RESUME',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      if (started) {
                        _duration =
                            const Duration(hours: 0, minutes: 0, seconds: 0);
                        started = onGoing = false;
                        resetTimer.cancel();
                      }
                    });
                  },
                  color: Colors.deepPurple,
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
