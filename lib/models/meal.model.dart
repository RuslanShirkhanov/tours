import 'unsigned.dart';

class MealModel {
  final U<int> id;
  final String name;

  const MealModel({
    required this.id,
    required this.name,
  });

  static MealModel serialize(Map<String, dynamic> data) => MealModel(
        id: U<int>(data['id'] as int),
        name: data['name'] as String,
      );

  static Map<String, dynamic> deserialize(MealModel data) => <String, dynamic>{
        'id': data.id.value,
        'name': data.name,
      };

  static List<MealModel> getMeals() => const [
        MealModel(id: U<int>(112), name: 'FB'),
        MealModel(id: U<int>(113), name: 'HB'),
        MealModel(id: U<int>(114), name: 'BB'),
        MealModel(id: U<int>(115), name: 'AI'),
        MealModel(id: U<int>(116), name: 'UAI'),
        MealModel(id: U<int>(117), name: 'RO'),
        MealModel(id: U<int>(121), name: 'FB+'),
        MealModel(id: U<int>(122), name: 'HB+'),
        MealModel(id: U<int>(129), name: 'SC'),
      ];
}
