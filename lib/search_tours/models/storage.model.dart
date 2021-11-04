import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';

import 'package:hot_tours/utils/pair.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';
import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/city.model.dart';
import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/models/star.model.dart';
import 'package:hot_tours/models/hotel.model.dart';
import 'package:hot_tours/models/meal.model.dart';

@immutable
class StorageModel {
  final DataModel data;

  const StorageModel(this.data);

  factory StorageModel.empty() => StorageModel(DataModel.empty());

  static DataModel mix(StorageModel storage, DataModel data) => DataModel(
        departCity: storage.data.departCity,
        targetCountry: storage.data.targetCountry,
        tourDates: data.tourDates,
        nightsCount: data.nightsCount,
        peopleCount: data.peopleCount,
        childrenAges: data.childrenAges,
        targetCities: storage.data.targetCities,
        hotelStars: storage.data.hotelStars,
        hotels: storage.data.hotels,
        meals: storage.data.meals,
        rate: storage.data.rate,
        tour: data.tour,
        name: data.name,
        number: data.number,
      );

  static StorageModel fromData(DataModel data) => StorageModel(data);

  static StorageModel serialize(Map<String, dynamic> data) => StorageModel(
        DataModel(
          departCity: DepartCityModel.serialize(
            data['departCity']! as Map<String, dynamic>,
          ),
          tourDates: [],
          targetCountry: CountryModel.serialize(
            data['targetCountry']! as Map<String, dynamic>,
          ),
          nightsCount: Pair(
            U<int>(data['nightsMin'] as int),
            U<int>(data['nightsMax'] as int),
          ),
          peopleCount: Pair(
            U<int>(data['adults'] as int),
            U<int>(data['children'] as int),
          ),
          childrenAges: (data['childrenAges'] as List<dynamic>)
              .cast<int>()
              .map(U.of)
              .cast<U<int>>()
              .toList(),
          targetCities: (data['targetCities'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(CityModel.serialize)
              .cast<CityModel>()
              .toList(),
          hotelStars: (data['hotelStars'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(StarModel.serialize)
              .cast<StarModel>()
              .toList(),
          hotels: (data['hotels'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(HotelModel.serialize)
              .cast<HotelModel>()
              .toList(),
          meals: (data['meals'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(MealModel.serialize)
              .cast<MealModel>()
              .toList(),
          rate: U<double>(data['rate'] as double),
          tour: null,
          name: null,
          number: null,
        ),
      );

  static Map<String, dynamic> deserialize(StorageModel data) =>
      <String, dynamic>{
        'departCity': DepartCityModel.deserialize(data.data.departCity!),
        'targetCountry': CountryModel.deserialize(data.data.targetCountry!),
        'nightsMin': data.data.nightsCount!.fst.value,
        'nightsMax': data.data.nightsCount!.snd.value,
        'adults': data.data.peopleCount!.fst.value,
        'children': data.data.peopleCount!.snd.value,
        'childrenAges': data.data.childrenAges.map((age) => age.value).toList(),
        'targetCities':
            data.data.targetCities.map(CityModel.deserialize).toList(),
        'hotelStars': data.data.hotelStars.map(StarModel.deserialize).toList(),
        'hotels': data.data.hotels.map(HotelModel.deserialize).toList(),
        'meals': data.data.meals.map(MealModel.deserialize).toList(),
        'rate': data.data.rate?.value,
      };
}

@immutable
abstract class StorageController {
  static Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  static Future<File> get _localFile async =>
      File('${await _localPath}/storage.json');

  static Future<StorageModel> read() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final data = jsonDecode(contents) as Map<String, dynamic>;
      return StorageModel.serialize(data);
    } catch (e) {
      return StorageModel.empty();
    }
  }

  static Future write(StorageModel data) async {
    final file = await _localFile;
    final contents = jsonEncode(StorageModel.deserialize(data));
    return file.writeAsString(contents);
  }
}
