import 'package:equatable/equatable.dart';

import 'unsigned.dart';

import '../models/star.model.dart';

class HotelModel extends Equatable {
  final U<int> id;
  final U<int> townId;
  final String name;
  final StarModel star;
  final U<num> rate;
  final U<int> photosCount;

  const HotelModel({
    required this.id,
    required this.townId,
    required this.name,
    required this.star,
    required this.rate,
    required this.photosCount,
  });

  @override
  List<Object> get props => [name];

  static HotelModel serialize(Map<String, dynamic> data) => HotelModel(
        id: U<int>(data['Id'] as int),
        townId: U<int>(data['TownId'] as int),
        name: (data['Name'] as String).trim(),
        star: StarModel(
          id: U<int>(data['StarId'] as int),
          name: data['StarName'] as String,
        ),
        rate: U<num>(data['Rate'] as num),
        photosCount: U<int>(data['PhotosCount'] as int),
      );

  static Map<String, dynamic> deserialize(HotelModel data) => <String, dynamic>{
        'Id': data.id.value,
        'TownId': data.townId.value,
        'Name': data.name,
        'StarId': data.star.id.value,
        'StarName': data.star.name,
        'Rate': data.rate.value,
        'PhotosCount': data.photosCount.value,
      };
}
