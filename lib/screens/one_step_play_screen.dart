import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_item.dart';

class OneStepPlayScreen extends StatefulWidget {
  final TaskItem task;
  const OneStepPlayScreen({super.key, required this.task});

  @override
  State<OneStepPlayScreen> createState() => _OneStepPlayScreenState();
}

class _OneStepPlayScreenState extends State<OneStepPlayScreen> {
  int _stepIndex = 0;
  double _gaugeValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startStepTimer();
  }

  void _startStepTimer() {
    _gaugeValue = 0.0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_gaugeValue < 1.0) {
          _gaugeValue += 0.01;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Color _getGaugeColor(double value) {
    if (value < 0.4) {
      return Colors.blue;
    }
    if (value < 0.7) {
      return Colors.yellow;
    }
    if (value < 0.9) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _getGaugeColor(_gaugeValue),
                  width: 4,
                ),
              ),
              child: Text(
                widget.task.subSteps[_stepIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            LinearProgressIndicator(
              value: _gaugeValue,
              minHeight: 20,
              color: _getGaugeColor(_gaugeValue),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  if (_stepIndex < widget.task.subSteps.length - 1) {
                    setState(() => _stepIndex++);
                    _startStepTimer();
                  } else {
                    widget.task.isCompleted = true;
                    Navigator.pop(context);
                  }
                },
                child: const Text("완료 버튼 ✔️", style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
