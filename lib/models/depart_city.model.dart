import 'package:equatable/equatable.dart';

import 'unsigned.dart';

class DepartCityModel extends Equatable {
  final U<int> id;
  final String name;

  const DepartCityModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id];

  static DepartCityModel serialize(Map<String, dynamic> data) =>
      DepartCityModel(
        id: U(data['Id'] as int),
        name: (data['Name'] as String).trim(),
      );

  static Map<String, dynamic> deserialize(DepartCityModel data) =>
      <String, dynamic>{
        'Id': data.id.value,
        'Name': data.name,
      };
}
