import 'package:equatable/equatable.dart';

class Pair<A, B> extends Equatable {
  final A fst;
  final B snd;

  const Pair(this.fst, this.snd);

  @override
  List<Object> get props => [fst as Object, snd as Object];

  @override
  String toString() => '($fst, $snd)';
}

extension Range<A, B> on Pair<A?, B?> {
  bool get isEmpty => fst == null && snd == null;
  bool get isNotEmpty => fst != null && snd != null;
  Pair<A, B> get checked => Pair(fst!, snd!);
}
