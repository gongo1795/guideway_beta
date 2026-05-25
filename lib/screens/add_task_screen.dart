// lib/screens/add_task_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';

// 한 세트의 입력 데이터를 담을 임시 클래스
class TaskInputSet {
  TextEditingController controller = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? _selectedTime;
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // 할 일 세트들을 담아두는 리스트 (처음 켰을 때는 기본 1세트 제공)
  final List<TaskInputSet> _inputFields = [TaskInputSet()];
  bool _isAiProcessing = false;

  // 특정 줄(index)의 날짜 선택 팝업
  Future<void> _pickDate(int index) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
    );
    if (picked != null) {
      setState(() => _inputFields[index].selectedDate = picked);
    }
  }

  // 특정 줄(index)의 시간 선택 팝업
  Future<void> _pickTime(int index) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _inputFields[index]._selectedTime = picked);
    }
  }

  // 새로운 입력 줄 세트 추가하기
  void _addNewField() {
    setState(() {
      _inputFields.add(TaskInputSet());
    });
  }

  void _handleInsert() {
    // 글자가 아예 안 적힌 빈 칸은 제외하고 진짜 입력된 것만 필터링
    var validFields = _inputFields
        .where((field) => field.controller.text.trim().isNotEmpty)
        .toList();
    if (validFields.isEmpty) return;

    setState(() => _isAiProcessing = true);

    Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() => _isAiProcessing = false);

      // 메인 화면으로 가공된 개별 퀘스트 묶음을 포장해서 토스!
      List<Map<String, dynamic>> processedDataList = validFields.map((field) {
        return {
          'title': field.controller.text.trim(),
          'targetDay': field.selectedDate?.day, // 고유 날짜 (없으면 null)
          'timeText': field._selectedTime != null
              ? field._selectedTime!.format(context)
              : "AI 자동 배정", // 고유 시간
        };
      }).toList();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text(
            "🪄 개별 일정 맞춤 가공 완료!",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "각 할 일마다 지정하신 개별 마감 조건을 반영하여\nAI가 실천 지침을 완벽하게 쪼개었습니다!",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB3B3),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.pop(context, processedDataList); // 팩 리스트 전송!
                },
                child: const Text(
                  "완료",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
      appBar: AppBar(title: const Text("스마트 퀘스트 멀티 생성"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isAiProcessing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 25),
                    Text(
                      "🤖 AI가 할 일별 마감 조건들을 개별 분석하여\n맞춤형 가이드를 생성하는 중...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // 📜 동적으로 늘어나는 입력 줄 리스트 영역
                  Expanded(
                    child: ListView.builder(
                      itemCount: _inputFields.length,
                      itemBuilder: (context, index) {
                        var field = _inputFields[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "퀘스트 #${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 1. 할 일 입력창
                                TextField(
                                  controller: field.controller,
                                  decoration: InputDecoration(
                                    hintText: "할 일을 적으세요 (예: 은행 가기)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // 2. 해당 줄 전용 날짜 및 시간 선택 버튼 행
                                Row(
                                  children: [
                                    // 날짜 버튼
                                    TextButton.icon(
                                      onPressed: () => _pickDate(index),
                                      icon: const Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                      ),
                                      label: Text(
                                        field.selectedDate == null
                                            ? "기본 날짜"
                                            : "${field.selectedDate!.month}/${field.selectedDate!.day}",
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // 시간 버튼
                                    TextButton.icon(
                                      onPressed: () => _pickTime(index),
                                      icon: const Icon(
                                        Icons.access_time,
                                        size: 18,
                                      ),
                                      label: Text(
                                        field._selectedTime == null
                                            ? "시간 자동"
                                            : field._selectedTime!.format(
                                                context,
                                              ),
                                      ),
                                    ),
                                    const Spacer(),
                                    // 여러 개 만들다가 한 줄 지우고 싶을 때 쓰는 휴지통
                                    if (_inputFields.length > 1)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => setState(
                                          () => _inputFields.removeAt(index),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ➕ 줄 추가하기 버튼
                  TextButton.icon(
                    onPressed: _addNewField,
                    icon: const Icon(Icons.add_circle_outline, size: 24),
                    label: const Text(
                      "다른 할 일도 같이 적기 ➕",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🚀 AI 제출 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB3B3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _handleInsert,
                      child: const Text(
                        "AI 마법으로 한 번에 추가하기 ✨",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
