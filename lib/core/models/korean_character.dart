import 'package:flutter/material.dart';

class StrokeCheckpoint {
  final Offset position;
  bool isReached;

  StrokeCheckpoint({required this.position, this.isReached = false});
}

