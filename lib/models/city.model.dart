import 'package:equatable/equatable.dart';

import 'unsigned.dart';

class CityModel extends Equatable {
  final U<int> id;
  final U<int> countryId;
  final String name;

  const CityModel({
    required this.id,
    required this.countryId,
    required this.name,
  });

  @override
  List<Object> get props => [name];

  static CityModel serialize(Map<String, dynamic> data) => CityModel(
        id: U(data['Id'] as int),
        countryId: U(data['CountryId'] as int),
        name: (data['Name'] as String).trim(),
      );

  static Map<String, dynamic> deserialize(CityModel data) => <String, dynamic>{
        'Id': data.id.value,
        'CountryId': data.countryId.value,
        'Name': data.name,
      };
}
