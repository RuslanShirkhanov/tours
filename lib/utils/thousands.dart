import 'package:hot_tours/models/unsigned.dart';

String thousands(U<int> _x) {
  final x = _x.value;
  assert(x >= 1000);
  final thousands = (x ~/ 1000).toString();
  return '$thousands ${x.toString().split('').reversed.take(x.toString().length - thousands.length).join().split('').reversed.join()}';
}
