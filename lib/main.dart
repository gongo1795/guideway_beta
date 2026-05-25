import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const GuideWayApp());
}

class GuideWayApp extends StatelessWidget {
  const GuideWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: 'NanumGothic', // 폰트 설정이 없으면 에러가 날 수 있어 주석처리합니다.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A8A)),
        scaffoldBackgroundColor: const Color(0xFFFFF9F9), // 배경색 설정 수정
        useMaterial3: true,
      ),
      home: const MainCalendarScreen(),
    );
  }
}

class TaskItem {
  String title;
  List<String> subSteps;
  bool isCompleted;
  TaskItem({
    required this.title,
    required this.subSteps,
    this.isCompleted = false,
  });
}

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  Map<int, List<TaskItem>> calendarData = {
    26: [
      TaskItem(
        title: "은행 가기",
        subSteps: ["신분증 챙기기", "버스 타기", "번호표 뽑기", "창구 방문하기"],
      ),
    ],
    25: [],
    27: [],
    28: [],
    29: [],
  };

  int selectedDay = 26;

  int getRemainingTasksCount(int day) {
    if (calendarData[day] == null) return 0;
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
        ), // 오타 수정함! (L -> E)
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
                  color: Colors.black.withOpacity(0.03),
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
                        if (taskCount > 0)
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
                          )
                        else
                          const Text("✨", style: TextStyle(fontSize: 14)),
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
                                    fontSize: 20,
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
                      final newTaskTitle = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTaskScreen(),
                        ),
                      );
                      if (newTaskTitle != null &&
                          newTaskTitle.toString().isNotEmpty) {
                        setState(() {
                          if (calendarData[selectedDay] == null)
                            calendarData[selectedDay] = [];
                          calendarData[selectedDay]!.add(
                            TaskItem(
                              title: newTaskTitle,
                              subSteps: [
                                "[$newTaskTitle] 준비하기",
                                "목적지로 이동하기",
                                "차분하게 실행하기",
                                "마무리하기",
                              ],
                            ),
                          );
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
                            final uncompletedTasks = calendarData[selectedDay]!
                                .where((t) => !t.isCompleted)
                                .toList();
                            if (uncompletedTasks.isNotEmpty) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OneStepPlayScreen(
                                    task: uncompletedTasks.first,
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

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isAiProcessing = false;

  void _handleInsert() {
    if (_controller.text.isEmpty) return;
    setState(() => _isAiProcessing = true);
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
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
    if (value < 0.4) return Colors.blue;
    if (value < 0.7) return Colors.yellow;
    if (value < 0.9) return Colors.orange;
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
