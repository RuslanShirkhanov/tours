import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/star.model.dart';

class TourModel {
  final U<int> hotelId; // 3
  final String hotelName; // 7
  final StarModel hotelStar; // 8
  final U<num> hotelRating; // 35

  final U<int> photosCount; // 46
  final String hotelDesc; // 38
  final String hotelDescUrl; // 2

  final String departCityName; // 33
  final String targetCountryName; // 31
  final String targetCityName; // 19 or 50

  final String dateIn; // 12
  final String dateOut; // 13
  final U<int> nightsCount; // 14

  final U<int> adultsCount; // 16
  final U<int> childrenCount; // 17

  final String roomType; // 9
  final String roomTypeDesc; // 36
  final String mealType; // 10
  final String mealTypeDesc; // 37

  final bool areTicketsIncluded; // 22

  final U<int> cost; // 42
  final String costCurrency; // 43

  const TourModel({
    required this.hotelId,
    required this.hotelName,
    required this.hotelStar,
    required this.hotelRating,
    required this.photosCount,
    required this.hotelDesc,
    required this.hotelDescUrl,
    required this.departCityName,
    required this.targetCountryName,
    required this.targetCityName,
    required this.dateIn,
    required this.dateOut,
    required this.nightsCount,
    required this.adultsCount,
    required this.childrenCount,
    required this.roomType,
    required this.roomTypeDesc,
    required this.mealType,
    required this.mealTypeDesc,
    required this.areTicketsIncluded,
    required this.cost,
    required this.costCurrency,
  });

  static TourModel serialize(List<dynamic> data) => TourModel(
        hotelId: U<int>(data[3] as int),
        hotelName: (data[7] as String).trim(),
        hotelStar: StarModel(
          id: StarModel.nameToId((data[8] as String).trim()),
          name: data[8] as String,
        ),
        hotelRating: U<num>(num.tryParse((data[35] as String).trim()) ?? 0.0),
        photosCount: U<int>(data[46] as int),
        hotelDesc: (data[38] as String).trim(),
        hotelDescUrl: (data[2] as String).trim(),
        departCityName: (data[33] as String).trim(),
        targetCountryName: (data[31] as String).trim(),
        targetCityName: (data[19] as String).trim(),
        dateIn: (data[12] as String).trim(),
        dateOut: (data[13] as String).trim(),
        nightsCount: U<int>(data[14] as int),
        adultsCount: U<int>(data[16] as int),
        childrenCount: U<int>(data[17] as int),
        roomType: (data[9] as String).trim(),
        roomTypeDesc: (data[37] as String).trim(),
        mealType: (data[10] as String).trim(),
        mealTypeDesc: (data[36] as String).trim(),
        areTicketsIncluded: int.parse((data[22] as String).trim()) == 1,
        cost: U<int>(data[42] as int),
        costCurrency: (data[43] as String).trim(),
      );

  static Map<String, dynamic> deserialize(TourModel data) => <String, dynamic>{
        'hotelId': data.hotelId,
        'hotelName': data.hotelName,
        'hotelStar': data.hotelStar,
        'hotelRating': data.hotelRating,
        'photosCount': data.photosCount,
        'hotelDesc': data.hotelDesc,
        'hotelDescUrl': data.hotelDescUrl,
        'departCity': data.departCityName,
        'targetCountry': data.targetCountryName,
        'targetCity': data.targetCityName,
        'dateIn': data.dateIn,
        'dateOut': data.dateOut,
        'nightsCount': data.nightsCount,
        'adultsCount': data.adultsCount,
        'childrenCount': data.childrenCount,
        'roomType': data.roomType,
        'roomTypeDesc': data.roomTypeDesc,
        'mealType': data.mealType,
        'mealTypeDesc': data.mealTypeDesc,
        'areTicketsIncluded': data.areTicketsIncluded,
        'cost': data.cost,
        'costCurrency': data.costCurrency,
      };
}
