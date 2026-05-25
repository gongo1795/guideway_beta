// lib/screens/main_calendar_screen.dart
import 'package:flutter/material.dart';
import '../models/task_item.dart';
import 'add_task_screen.dart';
import 'one_step_play_screen.dart';

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  Map<int, List<TaskItem>> calendarData = {
    25: [],
    26: [
      TaskItem(
        title: "은행 가기 (오전 11:00까지)",
        subSteps: ["신분증 챙기기", "버스 타기", "번호표 뽑기", "창구 방문하기"],
      ),
    ],
    27: [],
    28: [],
    29: [],
  };

  int selectedDay = 26;

  int getRemainingTasksCount(int day) {
    if (calendarData[day] == null) {
      return 0;
    }
    return calendarData[day]!.where((task) => !task.isCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🌳 GUIDEWAY 🌳",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5C4E4E),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "2026년 5월",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [25, 26, 27, 28, 29].map((day) {
                bool isSelected = selectedDay == day;
                int taskCount = getRemainingTasksCount(day);
                return GestureDetector(
                  onTap: () => setState(() => selectedDay = day),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFD1D1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$day일",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (taskCount > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "$taskCount",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else ...[
                          const Text("✨", style: TextStyle(fontSize: 14)),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "📋 $selectedDay일의 퀘스트 목록",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child:
                        calendarData[selectedDay] == null ||
                            calendarData[selectedDay]!.isEmpty
                        ? const Center(child: Text("오늘의 퀘스트가 없습니다!"))
                        : ListView.builder(
                            itemCount: calendarData[selectedDay]!.length,
                            itemBuilder: (context, index) {
                              final task = calendarData[selectedDay]![index];
                              return ListTile(
                                leading: task.isCompleted
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB3B3),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      final dynamic resultData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTaskScreen(),
                        ),
                      );

                      // ⭐ 넘어온 각각의 할 일 리스트를 돌면서 각각 지정된 날짜 방으로 똑똑하게 분류 분배!
                      if (resultData != null &&
                          resultData is List<Map<String, dynamic>>) {
                        setState(() {
                          for (var taskInfo in resultData) {
                            String taskTitle = taskInfo['title'];
                            int? designatedDay = taskInfo['targetDay'];
                            String timeConstraint = taskInfo['timeText'];

                            // 날짜 안 정했으면 메인에서 켜놓고 있던 날짜로 자동 배정
                            int finalDay = designatedDay ?? selectedDay;

                            if (calendarData[finalDay] == null) {
                              calendarData[finalDay] = [];
                            }

                            calendarData[finalDay]!.add(
                              TaskItem(
                                title: "$taskTitle ($timeConstraint)",
                                subSteps: [
                                  "[$taskTitle] 준비물 확인하기",
                                  "차분하게 시작하기",
                                  "안전하게 완료하기",
                                ],
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: const Text(
                      "➕ 할일 추가하기",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF91C8E4),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed:
                        (calendarData[selectedDay] == null ||
                            calendarData[selectedDay]!
                                .where((t) => !t.isCompleted)
                                .isEmpty)
                        ? null
                        : () async {
                            final List<TaskItem> uncompletedTasks =
                                calendarData[selectedDay]!
                                    .where((t) => !t.isCompleted)
                                    .toList();

                            if (uncompletedTasks.isNotEmpty) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OneStepPlayScreen(
                                    uncompletedTasks: uncompletedTasks,
                                  ),
                                ),
                              );
                              setState(() {});
                            }
                          },
                    child: const Text(
                      "🎮 할일 소화하기",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
