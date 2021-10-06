import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:hot_tours/utils/reqs.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/models/city.model.dart';
import 'package:hot_tours/models/hotel.model.dart';
import 'package:hot_tours/models/tour.model.dart';

import 'package:hot_tours/routes/feedback.route.dart';
import 'package:hot_tours/routes/request_error.route.dart';

abstract class Api {
  static final _dio = Dio();

  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static String _makeUri(
    String unencodedPath,
    Map<String, Object> queryParams,
  ) =>
      Uri.decodeFull(
        Uri.http(
          'ovz1.j7105307.m719m.vps.myjino.ru:49234',
          '/$unencodedPath',
          queryParams.map<String, String>(
            (key, value) => MapEntry(key, value.toString()),
          ),
        ).toString(),
      );

  static String makeImageUri({
    required U<int> hotelId,
    required U<int> imageNumber,
  }) =>
      'https://hotels.sletat.ru/i/f/${hotelId}_$imageNumber.jpg';

  static Future<List<DepartCityModel>> getDepartCities() async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('depart_cities', {});
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(DepartCityModel.serialize)
          .toList()
          .cast<DepartCityModel>();
    }
    return const [];
  }

  static Future<List<CountryModel>> getCountries({
    required U<int> townFromId,
  }) async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('countries', {
      'town_from_id': townFromId,
    });
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(CountryModel.serialize)
          .toList()
          .cast<CountryModel>();
    }
    return const [];
  }

  static Future<List<CityModel>> getCities({
    required U<int> countryId,
  }) async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('cities', {
      'country_id': countryId,
    });
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(CityModel.serialize)
          .toList()
          .cast<CityModel>();
    }
    return const [];
  }

  static Future<List<HotelModel>> getHotels({
    required U<int> countryId,
    required List<U<int>> towns,
    required List<U<int>> stars,
  }) async {
    assert(towns.isNotEmpty);
    assert(stars.isNotEmpty);

    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('hotels', {
      'country_id': countryId,
      'towns': towns.join(','),
      'stars': stars.join(','),
    });
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(HotelModel.serialize)
          .toList()
          .cast<HotelModel>();
    }
    return const [];
  }

  static Future<List<DateTime>> getTourDates({
    required U<int> departCityId,
    required U<int> countryId,
  }) async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('tour_dates', {
      'depart_city_id': departCityId,
      'country_id': countryId,
    });
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<String>()
          .map((date) {
            final parts = date.split('.').map(int.parse).toList();
            return DateTime(parts[2], parts[1], parts[0]);
          })
          .toList()
          .cast<DateTime>();
    }
    return const [];
  }

  static Future<List<TourModel>> getHotTours({
    required U<int> cityFromId,
    required U<int> countryId,
    required List<U<int>> stars,
  }) async {
    assert(stars.isNotEmpty);

    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('hot_tours', {
      'city_from_id': cityFromId,
      'country_id': countryId,
      'stars': stars.join(','),
    });
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<List<dynamic>>()
          .map(TourModel.serialize)
          .toList()
          .cast<TourModel>();
    }
    return const [];
  }

  static Future<List<TourModel>> getSeasonTours({
    required U<int> cityFromId,
    required U<int> countryId,
    required U<int> adults,
    required U<int> kids,
    required List<U<int>> kidsAges,
    required U<int> nightsMin,
    required U<int> nightsMax,
    required List<U<int>> meals,
    required List<U<int>> stars,
    required List<U<int>> hotels,
    required List<U<int>> cities,
  }) async {
    assert(meals.isNotEmpty);
    assert(stars.isNotEmpty);
    assert(hotels.isNotEmpty);
    assert(cities.isNotEmpty);

    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('season_tours', {
      'city_from_id': cityFromId,
      'country_id': countryId,
      'adults': adults,
      'kids': kids,
      if (kidsAges.isNotEmpty) 'kids_ages': kidsAges.join(','),
      'nights_min': nightsMin,
      'nights_max': nightsMax,
      'meals': meals.join(','),
      'stars': stars.join(','),
      'hotels': hotels.join(','),
      'cities': cities.join(','),
    });
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return (data['value'] as List<dynamic>)
          .cast<List<dynamic>>()
          .map(TourModel.serialize)
          .toList()
          .cast<TourModel>();
    }
    return const [];
  }

  static Future<bool> createLead({
    required String note,
  }) async {
    if (!await Api.hasConnection()) {
      return false;
    }

    final uri = _makeUri('create_lead', {'note': note});
    final res = await _dio.get<Map<String, dynamic>>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'ok') {
      return data['value'] as bool;
    }
    return false;
  }

  static void makeCreateLeadRequest({
    required BuildContext context,
    required ReqKind kind,
    required String note,
    bool isRepeated = false,
  }) {
    const snackBarTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
      color: Colors.white,
    );
    if (ReqsController.canSetReq(kind)) {
      Api.createLead(note: note).then((value) {
        if (value) {
          ReqsController.setReq(kind);
          showFeedbackRoute(context);
        } else {
          if (isRepeated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Снова неудача :(',
                  style: snackBarTextStyle,
                ),
              ),
            );
          } else {
            showRequestErrorRoute(context: context, kind: kind, data: note);
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'По заявке раз в 15 минут\nОсталось: ${ReqsController.rollback.value - ReqsController.howLong(kind).inMinutes}',
            style: snackBarTextStyle,
          ),
        ),
      );
    }
  }
}
