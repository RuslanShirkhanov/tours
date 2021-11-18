import 'package:hot_tours/utils/pair.dart';
import 'package:hot_tours/utils/string.dart';

import 'package:hot_tours/models/unsigned.dart';

abstract class Date {
  static DateTime parseDate(String value) {
    final values = value.split('.').map(int.parse).toList();
    return DateTime(values.last, values[1], values.first);
  }

  static String monthToString(int value) {
    assert(value >= 1 && value <= 12);
    return [
      'январь',
      'февраль',
      'март',
      'апрель',
      'май',
      'июнь',
      'июль',
      'август',
      'сентябрь',
      'октябрь',
      'ноябрь',
      'декабрь',
    ][value - 1];
  }

  static String weekdayToString(int value) {
    assert(value >= 1 && value <= 7);
    return ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'][value - 1];
  }

  static int _decRanged(int min, int max, int value) =>
      value == min ? max : value - 1;

  static int _incRanged(int min, int max, int value) =>
      value == max ? min : value + 1;

  static int decWeekday(int value) => _decRanged(1, 7, value);

  static int incWeekday(int value) => _incRanged(1, 7, value);
}

extension Utils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  int monthsCount(DateTime date) => 12 - date.month;

  List<DateTime> get nextMonths =>
      List.generate(12, (index) => DateTime(year, month + index));

  List<DateTime> get lastMonths => List.generate(
        12 - month + 1,
        (index) => DateTime(year, month + index),
      );

  int get daysCount => [
        DateTime.september,
        DateTime.april,
        DateTime.june,
        DateTime.november,
      ].contains(month)
          ? 30
          : [
              DateTime.january,
              DateTime.march,
              DateTime.may,
              DateTime.july,
              DateTime.august,
              DateTime.october,
              DateTime.december,
            ].contains(month)
              ? 31
              : year % 4 == 0
                  ? 29
                  : 28;
}

extension DateRange on Pair<DateTime?, DateTime?> {
  bool get isValid => isNotEmpty && fst!.compareTo(snd!) <= 0;

  bool contains(DateTime value) {
    if (!isValid) {
      return false;
    }
    final lower = value.compareTo(fst!) >= 0;
    final upper = value.compareTo(snd!) <= 0;
    return lower && upper;
  }

  Iterable<DateTime> get days sync* {
    if (!isValid) {
      return;
    }
    var date = fst!;
    do {
      yield date;
      date = date.copyWith(day: date.day + 1);
    } while (date.compareTo(snd!) <= 0);
  }

  String get pretty {
    if (isValid) {
      return '${fst!.day} ${declineWord(Date.monthToString(fst!.month), U(fst!.day)).substring(0, 3)} - ${snd!.day} ${declineWord(Date.monthToString(snd!.month), U(snd!.day)).substring(0, 3)}';
    }
    return '';
  }
}
