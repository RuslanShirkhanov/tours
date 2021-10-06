import 'dart:ui';

import 'package:hot_tours/models/unsigned.dart';

int _fadeHelp(int x) {
  final tmp = [];
  var a = x;
  while (a > 0) {
    tmp.add(a % 2);
    a ~/= 2;
  }
  return int.tryParse(tmp.reversed.join('')) ?? 0;
}

Color fade(U<num> rating) {
  final r = rating.value.toDouble();
  assert(r >= 0 && r <= 10);
  final x = _fadeHelp(r.round());
  return Color.fromARGB(255, 255 - x, 0 + x, 0);
}
