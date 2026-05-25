import 'package:flutter/material.dart';

void main() {
  runApp(const GuideWayApp());
}

class GuideWayApp extends StatelessWidget {
  const GuideWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 오른쪽 위 디버그 띠 숨기기
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const OneStepViewScreen(),
    );
  }
}

class OneStepViewScreen extends StatefulWidget {
  const OneStepViewScreen({super.key});

  @override
  State<OneStepViewScreen> createState() => _OneStepViewScreenState();
}

class _OneStepViewScreenState extends State<OneStepViewScreen> {
  // AI가 분할해준 시나리오 (데이터)
  final List<String> _tasks = [
    "신분증 챙기기",
    "집 앞 버스 정류장 가기",
    "700번 버스 타기",
    "시청역에서 내리기",
    "은행 번호표 뽑기",
  ];
  int _currentIndex = 0; // 현재 몇 번째 단계인지

  void _nextStep() {
    setState(() {
      if (_currentIndex < _tasks.length - 1) {
        _currentIndex++;
      } else {
        // 모든 단계 완료 시 알림
        _showCompleteDialog();
      }
    });
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("참 잘했어요! 🎉", textAlign: TextAlign.center),
        content: const Text("모든 일을 안전하게 마쳤습니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0); // 처음으로 리셋
            },
            child: const Text("확인", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 진행률 계산 (0.0 ~ 1.0)
    double progress = (_currentIndex + 1) / _tasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF), // 눈이 편안한 연한 하늘색 배경
      appBar: AppBar(
        title: const Text(
          "GUIDEWAY",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🎯 지금 할 일",
              style: TextStyle(fontSize: 22, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // [One-Step View] 현재 할 일 하나만 강조하는 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Text(
                _tasks[_currentIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // [시각적 타임 바] 현재 진행 상황을 게이지로 표시
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("시작", style: TextStyle(fontSize: 18)),
                Text("도착", style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 25,
                backgroundColor: Colors.grey[200],
                color: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 80),

            // [크고 누르기 쉬운 버튼]
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "다 했어요 ➡️",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
