// lib/screens/one_step_play_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_item.dart';

class OneStepPlayScreen extends StatefulWidget {
  final List<TaskItem> uncompletedTasks;

  const OneStepPlayScreen({super.key, required this.uncompletedTasks});

  @override
  State<OneStepPlayScreen> createState() => _OneStepPlayScreenState();
}

class _OneStepPlayScreenState extends State<OneStepPlayScreen> {
  int _currentTaskIndex = 0;
  int _currentStepIndex = 0; // 👈 정답 변수 이름!

  bool _hasStartedCurrentTask = false;
  double _gaugeValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hasStartedCurrentTask = false;
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
    if (value < 0.4) return Colors.blue;
    if (value < 0.7) return Colors.yellow;
    if (value < 0.9) return Colors.orange;
    return Colors.red;
  }

  void _handleNext() {
    TaskItem currentTask = widget.uncompletedTasks[_currentTaskIndex];

    if (_currentStepIndex < currentTask.subSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _startStepTimer();
    } else {
      _timer?.cancel();
      currentTask.isCompleted = true;

      if (_currentTaskIndex < widget.uncompletedTasks.length - 1) {
        setState(() {
          _currentTaskIndex++;
          _currentStepIndex = 0;
          _hasStartedCurrentTask = false;
        });
      } else {
        _showAllCompleteDialog();
      }
    }
  }

  void _showAllCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "🏆 올 클리어! 🎉",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        content: const Text(
          "오늘 계획한 모든 퀘스트를\n완벽하게 소화했습니다!\n정말 대단해요!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF79AC78),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "달력으로 돌아가기",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskItem currentTask = widget.uncompletedTasks[_currentTaskIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4),
      appBar: AppBar(title: const Text("🎮 퀘스트 연속 소화방"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🔥 오늘의 임무 (${_currentTaskIndex + 1} / ${widget.uncompletedTasks.length})",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            if (!_hasStartedCurrentTask) ...[
              const Spacer(),
              Text(
                "다음 할 일은?",
                style: TextStyle(fontSize: 22, color: Colors.grey[600]),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Text(
                  currentTask.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF91C8E4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    setState(() {
                      _hasStartedCurrentTask = true;
                    });
                    _startStepTimer();
                  },
                  child: const Text(
                    "시작하기 🚀",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ] else ...[
              Text(
                "🎯 목표: ${currentTask.title}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "단계 (${_currentStepIndex + 1} / ${currentTask.subSteps.length})",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 70,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: _getGaugeColor(_gaugeValue),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Text(
                  currentTask.subSteps[_currentStepIndex], // 👈 오타 원천 차단 완료!
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: _gaugeValue,
                  minHeight: 25,
                  backgroundColor: Colors.grey[300],
                  color: _getGaugeColor(_gaugeValue),
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 85,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF79AC78),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _handleNext,
                  child: const Text(
                    "완료 버튼 ✔️",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
