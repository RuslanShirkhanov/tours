import 'unsigned.dart';

class DepartCityModel {
  final U<int> id;
  final String name;
  final bool isPopular;

  const DepartCityModel({
    required this.id,
    required this.name,
    required this.isPopular,
  });

  static DepartCityModel serialize(Map<String, dynamic> data) =>
      DepartCityModel(
        id: U(data['Id'] as int),
        name: (data['Name'] as String).trim(),
        isPopular: data['IsPopular'] as bool,
      );

  static Map<String, dynamic> deserialize(DepartCityModel data) =>
      <String, dynamic>{
        'Id': data.id.value,
        'Name': data.name,
        'IsPopular': data.isPopular,
      };
}
