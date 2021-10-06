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

  factory DepartCityModel.empty() => DepartCityModel(
        id: U<int>(0),
        name: '',
        isPopular: false,
      );

  static DepartCityModel serialize(Map<String, dynamic> data) =>
      DepartCityModel(
        id: U<int>(data['Id'] as int),
        name: data['Name'] as String,
        isPopular: data['IsPopular'] as bool,
      );

  static Map<String, dynamic> deserialize(DepartCityModel data) => {
        'Id': data.id.value,
        'Name': data.name,
        'IsPopular': data.isPopular,
      };
}
