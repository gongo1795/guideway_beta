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
        fontFamily: 'NanumGothic', // 귀여운 폰트가 있다면 적용 가능
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8A8A), // 귀여운 파스텔 핑크/피치 톤
          background: const Color(0xFFFFF9F9),
        ),
        useMaterial3: true,
      ),
      home: const MainCalendarScreen(),
    );
  }
}

// 할 일 데이터 구조
class TaskItem {
  String title;
  List<String> subSteps; // AI가 쪼갠 세부 단계들
  bool isCompleted;
  TaskItem({required this.title, required this.subSteps, this.isCompleted = false});
}

// --- [ 1. 메인 달력 화면 ] ---
class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({super.key});

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  // 오늘 날짜 기준 예시 데이터 (5월 26일에 퀘스트 1개 기본 배치)
  Map<int, List<TaskItem>> calendarData = {
    26: [
      TaskItem(title: "은행 가기", subSteps: ["신분증 챙기기", "버스 타기", "번호표 뽑기", "창구 방문하기"])
    ],
    27: [],
    28: [],
  };

  int selectedDay = 26; // 기본 선택된 날짜

  // 남은 할 일 개수 계산
  int getRemainingTasksCount(int day) {
    if (calendarData[day] == null) return 0;
    return calendarData[day]!.where((task) => !task.isCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F9),
      appBar: AppBar(
        title: const Text("🌳 GUIDEWAY 🌳", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5C4L4L))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 귀여운 미니 달력 (5월 예시)
          const Text("2026년 5월", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
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
                      color: isSelected ? const Color(0xFFFFD1D1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text("$day일", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        // 할 일 개수 배지 (게임 퀘스트 알림 느낌)
                        if (taskCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10)),
                            child: Text("$taskCount", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
          
          // 선택한 날짜의 할 일 목록 리스트 확인창
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📋 $selectedDay일의 퀘스트 목록", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: calendarData[selectedDay]!.isEmpty
                        ? const Center(child: Text("오늘의 퀘스트가 없습니다!"))
                        : ListView.builder(
                            itemCount: calendarData[selectedDay]!.length,
                            itemBuilder: (context, index) {
                              final task = calendarData[selectedDay]![index];
                              return ListTile(
                                leading: task.isCompleted 
                                    ? const Icon(Icons.check_circle, color: Colors.green, size: 30)
                                    : const Icon(Icons.circle_outlined, color: Colors.grey, size: 30),
                                title: Text(
                                  task.title, 
                                  style: TextStyle(
                                    fontSize: 20, 
                                    fontWeight: FontWeight.bold,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    color: task.isCompleted ? Colors.grey : Colors.black
                                  )
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼 바
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      // 할 일 추가 페이지로 이동 후 결과 받아오기
                      final newTaskTitle = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTaskScreen()),
                      );
                      if (newTaskTitle != null && newTaskTitle.toString().isNotEmpty) {
                        setState(() {
                          // 가상의 AI 가 정리한 서브 스텝 추가
                          calendarData[selectedDay]!.add(TaskItem(
                            title: newTaskTitle,
                            subSteps: ["[$newTaskTitle] 준비하기", "목적지로 이동하기", "차분하게 실행하기", "마무리하고 정리하기"]
                          ));
                        });
                      }
                    },
                    child: const Text("➕ 할일 추가하기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF91C8E4),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: getRemainingTasksCount(selectedDay) == 0 ? null : () async {
                      // 완료되지 않은 첫 번째 할 일을 실행
                      final uncompletedTasks = calendarData[selectedDay]!.where((t) => !t.isCompleted).toList();
                      if (uncompletedTasks.isNotEmpty) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OneStepPlayScreen(task: uncompletedTasks.first),
                          ),
                        );
                        setState(() {}); // 다녀와서 달력 숫자 갱신
                      }
                    },
                    child: const Text("🎮 할일 소화하기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

// --- [ 2. 할 일 추가하기 화면 (AI 가공 연출 포함) ] ---
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

    // AI가 정리를 수행하는 듯한 2초 딜레이 연출
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isAiProcessing = false);
      
      // 완료 팝업 띄우기
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("🪄 AI 정렬 완료!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("AI가 할 일을 행동 단위로 세분화하고\n최적의 순서로 정렬했습니다!", textAlign: TextAlign.center),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.pop(context, _controller.text); // 메인으로 데이터 들고 가기
                },
                child: const Text("완료", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("새로운 퀘스트 등록")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _isAiProcessing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("🤖 AI가 실천하기 쉽게 단계를 쪼개고 있어요...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("무슨 일을 해야 하나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "예) 은행 가기, 방 청소하기",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text("언제까지 해야 하나요? (선택)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "예) 오후 3시까지 (비워두면 AI 자동 추천)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB3B3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _handleInsert,
                      child: const Text("추가하기 버튼", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

// --- [ 3. One-Step View 수행 화면 (색상 변화 타이머 게이지 포함) ] ---
class OneStepPlayScreen extends StatefulWidget {
  final TaskItem task;
  const OneStepPlayScreen({super.key, required this.task});

  @override
  State<OneStepPlayScreen> createState() => _OneStepPlayScreenState();
}

class _OneStepPlayScreenState extends State<OneStepPlayScreen> {
  int _stepIndex = 0;
  double _gaugeValue = 0.0; // 0.0 ~ 1.0 (시간이 흐를수록 차오름)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startStepTimer();
  }

  // 각 스텝마다 시간이 흐르는 시뮬레이션 타이머
  void _startStepTimer() {
    _gaugeValue = 0.0;
    _timer?.cancel();
    // 0.1초마다 게이지가 조금씩 차오름 (총 10초면 꽉 차는 프로토타입용 설정)
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_gaugeValue < 1.0) {
          _gaugeValue += 0.01; // 임박할수록 게이지 상승
        } else {
          _timer?.cancel(); // 시간 다 됨 (실제 앱에선 경고 알림 등)
        }
      });
    });
  }

  // 게이지 수치에 따라 색상이 동적으로 변하는 함수 (파랑 -> 노랑 -> 주황 -> 빨강)
  Color _getGaugeColor(double value) {
    if (value < 0.4) return Colors.blue;
    if (value < 0.7) return Colors.yellow;
    if (value < 0.9) return Colors.orange;
    return Colors.red;
  }

  void _nextSubStep() {
    if (_stepIndex < widget.task.subSteps.length - 1) {
      setState(() {
        _stepIndex++;
      });
      _startStepTimer(); // 다음 단계 타이머 리셋 및 재시작
    } else {
      _timer?.cancel();
      // 이 대업적 퀘스트의 모든 단계를 완전히 끝냈을 때
      widget.task.isCompleted = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("🎯 퀘스트 완료!!", textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green)),
          content: Text("'${widget.task.title}' 일정을 완벽히 소화했습니다!\n달력의 숫자가 줄어듭니다. ✨", textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.pop(context); // 메인 달력 화면으로 복귀
                },
                child: const Text("메인화면으로 가기", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentSubTask = widget.task.subSteps[_stepIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4), // 수행 중에는 집중을 돕는 연초록 배경
      appBar: AppBar(
        title: Text(widget.task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("단계 (${_stepIndex + 1} / ${widget.task.subSteps.length})", style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            // ⭐ [One-Step View] 오직 하나의 할 일만 거대하게 보여주는 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20)],
                border: Border.all(color: _getGaugeColor(_gaugeValue), width: 3), // 카드 테두리도 게이지 색상과 연동
              ),
              child: Text(
                currentSubTask,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
            ),
            const SizedBox(height: 60),

            // ⭐ [동적 색상 변경 제한 시간 게이지 바]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("⏳ 제한 시간 게이지", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                Text(
                  _gaugeValue >= 0.9 ? "🚨 마감 임박! 🚨" : "안전", 
                  style: TextStyle(color: _getGaugeColor(_gaugeValue), fontWeight: FontWeight.bold)
                )
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _gaugeValue,
                minHeight: 30,
                backgroundColor: Colors.grey[300],
                color: _getGaugeColor(_gaugeValue), // 실시간 색상 변환 점등!
              ),
            ),
            const Spacer(),

            // [완료 버튼]
            SizedBox(
              width: double.infinity,
              height: 85,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF79AC78),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 5,
                ),
                onPressed: _nextSubStep,
                child: const Text("완료 버튼 ✔️", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}