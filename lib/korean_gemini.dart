import 'package:flutter/material.dart';
import 'dart:math';

// 🌟 สังเกตว่าเราตัดคลาส KoreanLearningApp (ที่มี MaterialApp) ทิ้งไปเลย

// 1. โมเดลเก็บข้อมูลพิกัดของแต่ละสระ
class VowelModel {
  final String char;
  final String romanization;
  final List<List<Offset>> strokes; 

  VowelModel({
    required this.char,
    required this.romanization,
    required this.strokes,
  });
}

class KoreanLearningApp extends StatefulWidget {
  const KoreanLearningApp({super.key});

  @override
  State<KoreanLearningApp> createState() => _KoreanLearningAppState();
}

class _KoreanLearningAppState extends State<KoreanLearningApp> {
  // 2. คลังข้อมูลสระพื้นฐาน 10 ตัว
  final List<VowelModel> _vowels = [
    VowelModel(char: 'ㅏ', romanization: 'a', strokes: [
      [const Offset(130, 40), const Offset(130, 130), const Offset(130, 220)], 
      [const Offset(130, 130), const Offset(175, 130), const Offset(210, 130)], 
    ]),
    VowelModel(char: 'ㅑ', romanization: 'ya', strokes: [
      [const Offset(110, 40), const Offset(110, 130), const Offset(110, 220)], 
      [const Offset(110, 90), const Offset(155, 90), const Offset(190, 90)],  
      [const Offset(110, 170), const Offset(155, 170), const Offset(190, 170)], 
    ]),
    VowelModel(char: 'ㅓ', romanization: 'eo', strokes: [
      [const Offset(50, 130), const Offset(90, 130), const Offset(130, 130)],  
      [const Offset(130, 40), const Offset(130, 130), const Offset(130, 220)], 
    ]),
    VowelModel(char: 'ㅕ', romanization: 'yeo', strokes: [
      [const Offset(50, 90), const Offset(90, 90), const Offset(130, 90)],   
      [const Offset(50, 170), const Offset(90, 170), const Offset(130, 170)],  
      [const Offset(130, 40), const Offset(130, 130), const Offset(130, 220)], 
    ]),
    VowelModel(char: 'ㅗ', romanization: 'o', strokes: [
      [const Offset(130, 60), const Offset(130, 95), const Offset(130, 130)],  
      [const Offset(40, 130), const Offset(130, 130), const Offset(220, 130)], 
    ]),
    VowelModel(char: 'ㅛ', romanization: 'yo', strokes: [
      [const Offset(90, 60), const Offset(90, 95), const Offset(90, 130)],   
      [const Offset(170, 60), const Offset(170, 95), const Offset(170, 130)],  
      [const Offset(40, 130), const Offset(130, 130), const Offset(220, 130)], 
    ]),
    VowelModel(char: 'ㅜ', romanization: 'u', strokes: [
      [const Offset(40, 110), const Offset(130, 110), const Offset(220, 110)], 
      [const Offset(130, 110), const Offset(130, 160), const Offset(130, 210)], 
    ]),
    VowelModel(char: 'ㅠ', romanization: 'yu', strokes: [
      [const Offset(40, 110), const Offset(130, 110), const Offset(220, 110)], 
      [const Offset(90, 110), const Offset(90, 160), const Offset(90, 210)],   
      [const Offset(170, 110), const Offset(170, 160), const Offset(170, 210)],  
    ]),
    VowelModel(char: 'ㅡ', romanization: 'eu', strokes: [
      [const Offset(30, 130), const Offset(130, 130), const Offset(230, 130)], 
    ]),
    VowelModel(char: 'ㅣ', romanization: 'i', strokes: [
      [const Offset(130, 40), const Offset(130, 130), const Offset(130, 220)], 
    ]),
  ];

  int _currentVowelIndex = 0;    
  int _currentStrokeIndex = 0;   
  int _nextCheckpointIndex = 0;  

  List<Offset> _userCurrentPath = [];          
  List<List<Offset>> _completedStrokes = [];   
  bool _isVowelCompleted = false;              

  double _proximityThreshold = 28.0; 

  void _resetCanvas() {
    setState(() {
      _userCurrentPath.clear();
      _completedStrokes.clear();
      _currentStrokeIndex = 0;
      _nextCheckpointIndex = 0;
      _isVowelCompleted = false;
    });
  }

  void _checkTracerLogic(Offset userPoint) {
    if (_isVowelCompleted) return;

    VowelModel currentVowel = _vowels[_currentVowelIndex];
    List<Offset> activeStrokeCheckpoints = currentVowel.strokes[_currentStrokeIndex];
    Offset targetCheckpoint = activeStrokeCheckpoints[_nextCheckpointIndex];

    double distance = sqrt(pow(userPoint.dx - targetCheckpoint.dx, 2) +
        pow(userPoint.dy - targetCheckpoint.dy, 2));

    if (distance <= _proximityThreshold) {
      setState(() {
        _nextCheckpointIndex++;

        if (_nextCheckpointIndex >= activeStrokeCheckpoints.length) {
          _completedStrokes.add(List.from(activeStrokeCheckpoints));
          _userCurrentPath.clear();
          _currentStrokeIndex++;
          _nextCheckpointIndex = 0;

          if (_currentStrokeIndex >= currentVowel.strokes.length) {
            _isVowelCompleted = true;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    VowelModel currentVowel = _vowels[_currentVowelIndex];

    // 🌟 เริ่มต้นที่ Scaffold เลย เพราะเราอยู่ใต้ MaterialApp ของ main.dart แล้ว
    return Scaffold(
      appBar: AppBar(
        title: const Text('ฝึกเขียนสระเกาหลีพื้นฐาน'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.red.shade50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _vowels.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _currentVowelIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      '${_vowels[index].char} (${_vowels[index].romanization})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.red,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.red,
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _currentVowelIndex = index;
                          _resetCanvas();
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'สระเสียง: [ ${_vowels[_currentVowelIndex].romanization.toUpperCase()} ]',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text('จงลากนิ้วมือตามลำดับลูกศรให้ถูกต้อง', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: GestureDetector(
                onPanStart: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                  Offset canvasPoint = Offset(details.localPosition.dx, details.localPosition.dy);
                  
                  setState(() {
                    _userCurrentPath = [canvasPoint];
                  });
                  _checkTracerLogic(canvasPoint);
                },
                onPanUpdate: (details) {
                  Offset canvasPoint = Offset(details.localPosition.dx, details.localPosition.dy);
                  
                  setState(() {
                    _userCurrentPath.add(canvasPoint);
                  });
                  _checkTracerLogic(canvasPoint);
                },
                onPanEnd: (details) {
                  setState(() {
                    _userCurrentPath.clear(); 
                  });
                },
                child: CustomPaint(
                  size: const Size(260, 260),
                  painter: VowelPainter(
                    vowel: currentVowel,
                    userCurrentPath: _userCurrentPath,
                    completedStrokes: _completedStrokes,
                    currentStrokeIndex: _currentStrokeIndex,
                    nextCheckpointIndex: _nextCheckpointIndex,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (_isVowelCompleted)
            const Column(
              children: [
                Text('참 잘했어요! 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                Text('เก่งมากครับ! เขียนถูกต้องตามลำดับเส้น', style: TextStyle(color: Colors.green)),
              ],
            )
          else
            Text(
              'กำลังเขียนเส้นที่: ${_currentStrokeIndex + 1} / ${currentVowel.strokes.length}',
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          const Spacer(),
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
                    onPressed: _isVowelCompleted
                        ? () {
                            setState(() {
                              _currentVowelIndex = (_currentVowelIndex + 1) % _vowels.length;
                              _resetCanvas();
                            });
                          }
                        : null, 
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('สระถัดไป'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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

// 3. จิตรกรวาดเส้น (Custom Painter) 
class VowelPainter extends CustomPainter {
  final VowelModel vowel;
  final List<Offset> userCurrentPath;
  final List<List<Offset>> completedStrokes;
  final int currentStrokeIndex;
  final int nextCheckpointIndex;

  VowelPainter({
    required this.vowel,
    required this.userCurrentPath,
    required this.completedStrokes,
    required this.currentStrokeIndex,
    required this.nextCheckpointIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), gridPaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), gridPaint);

    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 24.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var stroke in vowel.strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], guidePaint);
      }
    }

    final arrowPaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (int s = 0; s < vowel.strokes.length; s++) {
      if (s >= completedStrokes.length) {
        var stroke = vowel.strokes[s];
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

    final successPaint = Paint()
      ..color = Colors.green.shade400
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var completedStroke in completedStrokes) {
      for (int i = 0; i < completedStroke.length - 1; i++) {
        canvas.drawLine(completedStroke[i], completedStroke[i + 1], successPaint);
      }
    }

    if (userCurrentPath.length > 1) {
      final userPaint = Paint()
        ..color = Colors.blue.shade600
        ..strokeWidth = 16.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < userCurrentPath.length - 1; i++) {
        canvas.drawLine(userCurrentPath[i], userCurrentPath[i + 1], userPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VowelPainter oldDelegate) {
    return true; 
  }
}