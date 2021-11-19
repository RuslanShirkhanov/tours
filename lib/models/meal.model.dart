import 'unsigned.dart';

class MealModel {
  final U<int> id;
  final String name;

  const MealModel({
    required this.id,
    required this.name,
  });

  static MealModel serialize(Map<String, dynamic> data) => MealModel(
        id: U(data['id'] as int),
        name: (data['name'] as String).trim(),
      );

  static Map<String, dynamic> deserialize(MealModel data) => <String, dynamic>{
        'id': data.id.value,
        'name': data.name,
      };

  static List<MealModel> getMeals() => const [
        MealModel(id: U(112), name: 'FB'),
        MealModel(id: U(113), name: 'HB'),
        MealModel(id: U(114), name: 'BB'),
        MealModel(id: U(115), name: 'AI'),
        MealModel(id: U(116), name: 'UAI'),
        MealModel(id: U(117), name: 'RO'),
        MealModel(id: U(121), name: 'FB+'),
        MealModel(id: U(122), name: 'HB+'),
        MealModel(id: U(129), name: 'SC'),
      ];
}

String mealToString(MealModel data) {
  late String result;
  switch (data.name.toUpperCase()) {
    case 'FB':
      result = 'Полный пансион';
      break;
    case 'HB':
      result = 'Полупансион';
      break;
    case 'BB':
      result = 'Только завтрак';
      break;
    case 'AI':
      result = 'Всё включено';
      break;
    case 'UAI':
      result = 'Ультра всё включено';
      break;
    case 'RO':
      result = 'Без питания';
      break;
    case 'FB+':
      result = 'Полный пансион+';
      break;
    case 'HB+':
      result = 'Полупансион+';
      break;
    case 'SC':
      result = 'Самообслуживание';
      break;
    default:
      result = '';
      break;
  }
  return result + ' (${data.name})';
}
