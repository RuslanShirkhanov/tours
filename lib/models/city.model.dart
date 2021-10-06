import 'unsigned.dart';

class CityModel {
  final U<int> id;
  final U<int> countryId;
  final String name;
  final bool isPopular;

  const CityModel({
    required this.id,
    required this.countryId,
    required this.name,
    required this.isPopular,
  });

  factory CityModel.any() => const CityModel(
        id: U<int>(0),
        countryId: U<int>(0),
        name: 'Любой',
        isPopular: false,
      );

  static CityModel serialize(Map<String, dynamic> data) => CityModel(
        id: U<int>(data['Id'] as int),
        countryId: U<int>(data['CountryId'] as int),
        name: data['Name'] as String,
        isPopular: data['IsPopular'] as bool,
      );

  static Map<String, dynamic> deserialize(CityModel data) => <String, dynamic>{
        'Id': data.id.value,
        'CountryId': data.countryId.value,
        'Name': data.name,
        'IsPopular': data.isPopular,
      };
}
