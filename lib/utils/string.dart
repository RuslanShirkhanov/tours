import 'package:hot_tours/models/unsigned.dart';

String declineWord(String word, U<int> number) {
  switch (word) {
    case 'декабрь':
      return 'декабря';
    case 'январь':
      return 'января';
    case 'февраль':
      return 'февраля';
    case 'март':
      return 'марта';
    case 'апрель':
      return 'апреля';
    case 'май':
      return 'мая';
    case 'июнь':
      return 'июня';
    case 'июль':
      return 'июля';
    case 'август':
      return 'августа';
    case 'сентябрь':
      return 'сентября';
    case 'октябрь':
      return 'октября';
    case 'ноябрь':
      return 'ноября';
    case 'взрослый':
      switch (number.value) {
        case 0:
        case 1:
          return 'взрослый';
        default:
          return 'взрослых';
      }
    case 'ребёнок':
      switch (number.value) {
        case 0:
          return 'детей';
        case 1:
          return 'ребёнок';
        case 2:
        case 3:
        case 4:
          return 'ребёнка';
        default:
          return 'детей';
      }
    case 'ночь':
      switch (number.value) {
        case 0:
          return 'ночей';
        case 1:
          return 'ночь';
        case 2:
        case 3:
        case 4:
          return 'ночи';
        default:
          return 'ночей';
      }
    default:
      throw Exception('Unknown word');
  }
}

extension Capitalized on String {
  String get capitalized {
    if (isEmpty) {
      return this;
    } else if (length == 1) {
      return toUpperCase();
    } else {
      return '${this[0].toUpperCase()}${substring(1)}';
    }
  }
}

extension Uncapitalized on String {
  String get uncapitalized {
    if (isEmpty) {
      return this;
    } else if (length == 1) {
      return toLowerCase();
    } else {
      return '${this[0].toLowerCase()}${substring(1)}';
    }
  }
}
