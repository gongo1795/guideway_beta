import 'dart:async';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isAiProcessing = false;

  void _handleInsert() {
    if (_controller.text.isEmpty) {
      return;
    }
    setState(() => _isAiProcessing = true);
    Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() => _isAiProcessing = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("🪄 AI 정렬 완료!", textAlign: TextAlign.center),
          content: const Text("AI가 단계를 나누고 정렬했습니다!"),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, _controller.text);
                },
                child: const Text("완료"),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("퀘스트 등록")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _isAiProcessing
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: "할 일"),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: _handleInsert,
                      child: const Text("추가하기"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
