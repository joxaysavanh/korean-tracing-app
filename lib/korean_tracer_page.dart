import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

// ----------------------------------------------------
// 1. โมเดลเก็บข้อมูลตัวอักษรเกาหลี (ใช้ร่วมกันทั้งสระและพยัญชนะ)
// ----------------------------------------------------
class KoreanChar {
  final String char;
  final String romanization;
  final List<List<Offset>> strokes;

  KoreanChar({required this.char, required this.romanization, required this.strokes});
}

// ฟังก์ชันช่วยย่อคำสั่ง Offset ให้โค้ดสั้นลง
Offset O(double x, double y) => Offset(x, y);

// ----------------------------------------------------
// 2. ฐานข้อมูล สระ 10 ตัว & พยัญชนะ 19 ตัว
// ----------------------------------------------------
final List<KoreanChar> vowelData = [
  KoreanChar(char: 'ㅏ', romanization: 'a (อา)', strokes: [[O(130, 40), O(130, 220)], [O(130, 130), O(210, 130)]]),
  KoreanChar(char: 'ㅑ', romanization: 'ya (ยา)', strokes: [[O(110, 40), O(110, 220)], [O(110, 90), O(190, 90)], [O(110, 170), O(190, 170)]]),
  KoreanChar(char: 'ㅓ', romanization: 'eo (ออ)', strokes: [[O(50, 130), O(130, 130)], [O(130, 40), O(130, 220)]]),
  KoreanChar(char: 'ㅕ', romanization: 'yeo (ยอ)', strokes: [[O(50, 90), O(130, 90)], [O(50, 170), O(130, 170)], [O(130, 40), O(130, 220)]]),
  KoreanChar(char: 'ㅗ', romanization: 'o (โอ)', strokes: [[O(130, 60), O(130, 130)], [O(40, 130), O(220, 130)]]),
  KoreanChar(char: 'ㅛ', romanization: 'yo (โย)', strokes: [[O(90, 60), O(90, 130)], [O(170, 60), O(170, 130)], [O(40, 130), O(220, 130)]]),
  KoreanChar(char: 'ㅜ', romanization: 'u (อู)', strokes: [[O(40, 110), O(220, 110)], [O(130, 110), O(130, 210)]]),
  KoreanChar(char: 'ㅠ', romanization: 'yu (ยู)', strokes: [[O(40, 110), O(220, 110)], [O(90, 110), O(90, 210)], [O(170, 110), O(170, 210)]]),
  KoreanChar(char: 'ㅡ', romanization: 'eu (อือ)', strokes: [[O(30, 130), O(230, 130)]]),
  KoreanChar(char: 'ㅣ', romanization: 'i (อี)', strokes: [[O(130, 40), O(130, 220)]]),
];

final List<KoreanChar> consonantData = [
  // พยัญชนะเดี่ยว (14 ตัว)
  KoreanChar(char: 'ㄱ', romanization: 'g/k (คีย็อก)', strokes: [[O(60, 60), O(200, 60), O(200, 200)]]),
  KoreanChar(char: 'ㄴ', romanization: 'n (นีอึน)', strokes: [[O(60, 60), O(60, 200), O(200, 200)]]),
  KoreanChar(char: 'ㄷ', romanization: 'd/t (ทีกึด)', strokes: [[O(60, 60), O(200, 60)], [O(60, 60), O(60, 200), O(200, 200)]]),
  KoreanChar(char: 'ㄹ', romanization: 'r/l (รีอึล)', strokes: [[O(60, 60), O(200, 60), O(200, 120)], [O(60, 120), O(200, 120)], [O(60, 120), O(60, 200), O(200, 200)]]),
  KoreanChar(char: 'ㅁ', romanization: 'm (มีอึม)', strokes: [[O(60, 60), O(60, 200)], [O(60, 60), O(200, 60), O(200, 200)], [O(60, 200), O(200, 200)]]),
  KoreanChar(char: 'ㅂ', romanization: 'b/p (พีอึบ)', strokes: [[O(80, 40), O(80, 220)], [O(180, 40), O(180, 220)], [O(80, 120), O(180, 120)], [O(80, 220), O(180, 220)]]),
  KoreanChar(char: 'ㅅ', romanization: 's (ชีอด)', strokes: [[O(130, 40), O(60, 220)], [O(130, 100), O(200, 220)]]),
  KoreanChar(char: 'ㅇ', romanization: 'ng (อีอึง)', strokes: [[O(130, 40), O(70, 60), O(40, 130), O(70, 200), O(130, 220), O(190, 200), O(220, 130), O(190, 60), O(130, 40)]]),
  KoreanChar(char: 'ㅈ', romanization: 'j/ch (ชีอึด)', strokes: [[O(60, 60), O(200, 60)], [O(130, 60), O(60, 220)], [O(130, 120), O(200, 220)]]),
  KoreanChar(char: 'ㅊ', romanization: 'ch (ชี่อึด)', strokes: [[O(130, 20), O(130, 60)], [O(60, 60), O(200, 60)], [O(130, 60), O(60, 220)], [O(130, 120), O(200, 220)]]),
  KoreanChar(char: 'ㅋ', romanization: 'k (คีอึก)', strokes: [[O(60, 60), O(200, 60), O(200, 220)], [O(60, 130), O(200, 130)]]),
  KoreanChar(char: 'ㅌ', romanization: 't (ทีอึด)', strokes: [[O(60, 60), O(200, 60)], [O(60, 130), O(200, 130)], [O(60, 60), O(60, 220), O(200, 220)]]),
  KoreanChar(char: 'ㅍ', romanization: 'p (พีอึบ)', strokes: [[O(60, 40), O(200, 40)], [O(100, 40), O(100, 180)], [O(160, 40), O(160, 180)], [O(60, 180), O(200, 180)]]),
  KoreanChar(char: 'ㅎ', romanization: 'h (ฮีอึด)', strokes: [[O(130, 20), O(130, 60)], [O(60, 60), O(200, 60)], [O(130, 90), O(70, 120), O(50, 160), O(70, 200), O(130, 220), O(190, 200), O(210, 160), O(190, 120), O(130, 90)]]),
  // พยัญชนะคู่ (5 ตัว)
  KoreanChar(char: 'ㄲ', romanization: 'kk (ซังกีย็อก)', strokes: [[O(40, 60), O(120, 60), O(120, 200)], [O(140, 60), O(220, 60), O(220, 200)]]),
  KoreanChar(char: 'ㄸ', romanization: 'tt (ซังทีกึด)', strokes: [[O(40, 60), O(120, 60)], [O(40, 60), O(40, 200), O(120, 200)], [O(140, 60), O(220, 60)], [O(140, 60), O(140, 200), O(220, 200)]]),
  KoreanChar(char: 'ㅃ', romanization: 'pp (ซังพีอึบ)', strokes: [[O(40, 40), O(40, 220)], [O(100, 40), O(100, 220)], [O(40, 120), O(100, 120)], [O(40, 220), O(100, 220)], [O(160, 40), O(160, 220)], [O(220, 40), O(220, 220)], [O(160, 120), O(220, 120)], [O(160, 220), O(220, 220)]]),
  KoreanChar(char: 'ㅆ', romanization: 'ss (ซังชีอด)', strokes: [[O(80, 40), O(40, 220)], [O(80, 100), O(120, 220)], [O(180, 40), O(140, 220)], [O(180, 100), O(220, 220)]]),
  KoreanChar(char: 'ㅉ', romanization: 'jj (ซังชีอึด)', strokes: [[O(40, 60), O(120, 60)], [O(80, 60), O(40, 220)], [O(80, 120), O(120, 220)], [O(140, 60), O(220, 60)], [O(180, 60), O(140, 220)], [O(180, 120), O(220, 220)]]),
];

// ----------------------------------------------------
// 3. หน้าจอหลักแบบมี Tab เปลี่ยนหมวดหมู่ (Vowels / Consonants)
// ----------------------------------------------------
class KoreanTracerPage extends StatelessWidget {
  const KoreanTracerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // มี 2 แท็บ
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learn Korean App'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_sharp),
          ),
          bottom: const TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.redAccent,
            indicatorWeight: 4,
            tabs: [
              Tab(text: 'ສະຫຼະ (สระ)',),
              Tab(text: 'ພະຍັນຊະນະ (พยัญชนะ)',),
            ],
          ),
        ),
        // หน้าจอเนื้อหาข้างในตามแท็บที่เลือก
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // ปิดการปัดหน้าจอเพื่อป้องกันการกวนตอนวาดเส้น
          children: [
            TracerCanvasView(charList: vowelData, categoryColor: Colors.blue),
            TracerCanvasView(charList: consonantData, categoryColor: Colors.red),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 4. กระดานวาดเขียน (แยกระบบมาเพื่อความสะอาดของโค้ด)
// ----------------------------------------------------
class TracerCanvasView extends StatefulWidget {
  final List<KoreanChar> charList;
  final Color categoryColor;

  const TracerCanvasView({super.key, required this.charList, required this.categoryColor});

  @override
  State<TracerCanvasView> createState() => _TracerCanvasViewState();
}

class _TracerCanvasViewState extends State<TracerCanvasView> {
  final FlutterTts flutterTts = FlutterTts();

  int _currentIndex = 0;    
  int _currentStrokeIndex = 0;   
  int _nextCheckpointIndex = 0;  

  List<Offset> _userCurrentPath = [];          
  List<List<Offset>> _completedStrokes = [];   
  bool _isCompleted = false;              
  double _proximityThreshold = 35.0; 

  @override
  void initState() {
    super.initState();
    _setupTTS();
  }

  Future<void> _setupTTS() async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.4); // พูดช้าๆ ให้ฟังชัดๆ
  }

  Future<void> _speakChar(String text) async {
    await flutterTts.speak(text);
  }

  void _resetCanvas() {
    setState(() {
      _userCurrentPath.clear();
      _completedStrokes.clear();
      _currentStrokeIndex = 0;
      _nextCheckpointIndex = 0;
      _isCompleted = false;
    });
  }

  void _checkTracerLogic(Offset userPoint) {
    if (_isCompleted) return;

    KoreanChar currentChar = widget.charList[_currentIndex];
    List<Offset> activeStrokeCheckpoints = currentChar.strokes[_currentStrokeIndex];
    Offset targetCheckpoint = activeStrokeCheckpoints[_nextCheckpointIndex];

    double distance = sqrt(pow(userPoint.dx - targetCheckpoint.dx, 2) + pow(userPoint.dy - targetCheckpoint.dy, 2));

    if (distance <= _proximityThreshold) {
      setState(() {
        _nextCheckpointIndex++;

        if (_nextCheckpointIndex >= activeStrokeCheckpoints.length) {
          _completedStrokes.add(List.from(activeStrokeCheckpoints));
          _userCurrentPath.clear();
          _currentStrokeIndex++;
          _nextCheckpointIndex = 0;

          if (_currentStrokeIndex >= currentChar.strokes.length) {
            _isCompleted = true;
            _speakChar(currentChar.char); // 🌟 พูดเสียงทันทีที่เขียนเสร็จ!
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    KoreanChar currentChar = widget.charList[_currentIndex];

    return Column(
      children: [
        // แถบเลื่อนตัวอักษรด้านบน
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: widget.categoryColor.withOpacity(0.1),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.charList.length,
            itemBuilder: (context, index) {
              bool isSelected = index == _currentIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    widget.charList[index].char,
                    style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : widget.categoryColor, fontSize: 18),
                  ),
                  selected: isSelected,
                  selectedColor: widget.categoryColor,
                  backgroundColor: Colors.white,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _currentIndex = index;
                        _resetCanvas();
                        _speakChar(widget.charList[index].char); // กดปุ๊บ พูดปั๊บ
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),

        // โซนแสดงคำอ่านและปุ่มฟังเสียง
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${currentChar.char}  [ ${currentChar.romanization} ]',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.volume_up, color: widget.categoryColor),
              onPressed: () => _speakChar(currentChar.char),
            ),
          ],
        ),
        const Text('จงลากนิ้วตามทิศทางลูกศร', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 15),

        // กระดานวาด
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)],
            ),
            child: GestureDetector(
              onPanStart: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                Offset canvasPoint = Offset(details.localPosition.dx, details.localPosition.dy);
                setState(() => _userCurrentPath = [canvasPoint]);
                _checkTracerLogic(canvasPoint);
              },
              onPanUpdate: (details) {
                Offset canvasPoint = Offset(details.localPosition.dx, details.localPosition.dy);
                setState(() => _userCurrentPath.add(canvasPoint));
                _checkTracerLogic(canvasPoint);
              },
              onPanEnd: (details) => setState(() => _userCurrentPath.clear()),
              child: CustomPaint(
                size: const Size(260, 260),
                painter: CharPainter(
                  charData: currentChar,
                  userCurrentPath: _userCurrentPath,
                  completedStrokes: _completedStrokes,
                  currentStrokeIndex: _currentStrokeIndex,
                  themeColor: widget.categoryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // สเตตัส
        if (_isCompleted)
          const Column(
            children: [
              Text('참 잘했어요! 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
              Text('เก่งมาก! เขียนถูกต้อง', style: TextStyle(color: Colors.green)),
            ],
          )
        else
          Text(
            'กำลังเขียนเส้นที่: ${_currentStrokeIndex + 1} / ${currentChar.strokes.length}',
            style: TextStyle(fontSize: 16, color: widget.categoryColor, fontWeight: FontWeight.bold),
          ),
          
        const Spacer(),
        // ปุ่มล่างสุด
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetCanvas,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ล้างหน้าจอ'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCompleted
                      ? () {
                          setState(() {
                            _currentIndex = (_currentIndex + 1) % widget.charList.length;
                            _resetCanvas();
                          });
                        }
                      : null, 
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('ตัวถัดไป'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.categoryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------
// 5. จิตรกรวาดเส้น
// ----------------------------------------------------
class CharPainter extends CustomPainter {
  final KoreanChar charData;
  final List<Offset> userCurrentPath;
  final List<List<Offset>> completedStrokes;
  final int currentStrokeIndex;
  final Color themeColor;

  CharPainter({
    required this.charData,
    required this.userCurrentPath,
    required this.completedStrokes,
    required this.currentStrokeIndex,
    required this.themeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.grey.shade100..strokeWidth = 1.0;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), gridPaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), gridPaint);

    final guidePaint = Paint()..color = Colors.grey.shade300..strokeWidth = 24.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;

    for (var stroke in charData.strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], guidePaint);
      }
    }

    final arrowPaint = Paint()..color = Colors.black38..strokeWidth = 3.0..style = PaintingStyle.stroke;
    for (int s = 0; s < charData.strokes.length; s++) {
      if (s >= completedStrokes.length) {
        var stroke = charData.strokes[s];
        if (stroke.length >= 2) {
          Offset start = stroke[0];
          Offset next = stroke[1];
          canvas.drawCircle(start, 6, Paint()..color = Colors.orange);
          double angle = atan2(next.dy - start.dy, next.dx - start.dx);
          Offset arrowEnd = Offset(start.dx + cos(angle) * 20, start.dy + sin(angle) * 20);
          canvas.drawLine(start, arrowEnd, arrowPaint);
        }
      }
    }

    final successPaint = Paint()..color = Colors.green.shade400..strokeWidth = 20.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    for (var completedStroke in completedStrokes) {
      for (int i = 0; i < completedStroke.length - 1; i++) {
        canvas.drawLine(completedStroke[i], completedStroke[i + 1], successPaint);
      }
    }

    if (userCurrentPath.length > 1) {
      final userPaint = Paint()..color = themeColor..strokeWidth = 16.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
      for (int i = 0; i < userCurrentPath.length - 1; i++) {
        canvas.drawLine(userCurrentPath[i], userCurrentPath[i + 1], userPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CharPainter oldDelegate) => true; 
}