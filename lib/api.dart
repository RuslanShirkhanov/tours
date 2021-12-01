import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

import 'package:hot_tours/utils/pair.dart';
import 'package:hot_tours/utils/reqs.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/models/city.model.dart';
import 'package:hot_tours/models/hotel.model.dart';
import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/models/hotel_comment.model.dart';
import 'package:hot_tours/models/actualized_price.model.dart';

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

  static Future<List<DepartCityModel>> getDepartCities({
    required bool showcase,
  }) async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('depart_cities', {
      'showcase': showcase,
    });
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
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
    required bool showcase,
  }) async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('countries', {
      'town_from_id': townFromId,
      'showcase': showcase,
    });
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      final result = (data['value'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(CountryModel.serialize)
          .cast<CountryModel>();
      return (showcase
              ? result
              : result.where(
                  (country) =>
                      country.hasTickets &&
                      country.hotelIsNotInStop &&
                      country.areTicketsIncluded,
                ))
          .toList();
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
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
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
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('hotels', {
      'country_id': countryId,
      'towns': towns.join(','),
      'stars': stars.join(','),
    });
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      return (data['value'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(HotelModel.serialize)
          .toList()
          .cast<HotelModel>();
    }
    return const [];
  }

  static Future<List<HotelCommentModel>> getHotelComments({
    required U<int> hotelId,
  }) async {
    if (!await Api.hasConnection()) {
      return [];
    }

    final uri = _makeUri('hotel_comments', {
      'hotel_id': hotelId,
    });
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      final xml = XmlDocument.parse(data['value'] as String);
      return xml
          .findAllElements('a:HotelComment')
          .map(HotelCommentModel.serialize)
          .toList();
    }
    return [];
  }

  static Future<String> getHotelDescription({
    required U<int> hotelId,
  }) async {
    if (!await Api.hasConnection()) {
      return '';
    }

    final uri = _makeUri('hotel_description', {
      'hotel_id': hotelId,
    });
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      try {
        final xml = XmlDocument.parse(data['value'] as String);
        final root = xml.getElement('html')!.getElement('body')!;
        return root.text.replaceAll(RegExp(' +'), ' ').trim();
      } catch (error) {
        return '';
      }
    }
    return '';
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
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
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
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      final value = data['value'] as Map<String, dynamic>;
      return TourModel.serialize(value);
    }
    return const [];
  }

  static String showDate(DateTime value) {
    String showDay(int value) {
      final shown = value.toString();
      return shown.length == 1 ? '0$shown' : shown;
    }

    String showMonth(int value) {
      final shown = value.toString();
      return shown.length == 1 ? '0$shown' : shown;
    }

    String showYear(int value) {
      final shown = value.toString();
      return shown.length == 1 ? '0$shown' : shown;
    }

    final day = showDay(value.day);
    final month = showMonth(value.month);
    final year = showYear(value.year);

    return '$day/$month/$year';
  }

  static Future<List<TourModel>> getSeasonTours({
    required U<int> cityFromId,
    required U<int> countryId,
    required Pair<U<int>, U<int>> peopleCount,
    required List<U<int>> kidsAges,
    required Pair<U<int>, U<int>> nightsCount,
    required Pair<DateTime, DateTime> tourDates,
    required List<U<int>> meals,
    required List<U<int>> stars,
    required List<U<int>> hotels,
    required List<U<int>> cities,
  }) async {
    if (!await Api.hasConnection()) {
      return const [];
    }

    final uri = _makeUri('season_tours', {
      'city_from_id': cityFromId,
      'country_id': countryId,
      'adults': peopleCount.fst,
      'kids': peopleCount.snd,
      if (kidsAges.isNotEmpty) 'kids_ages': kidsAges.join(','),
      'nights_min': nightsCount.fst,
      'nights_max': nightsCount.snd,
      'depart_from': showDate(tourDates.fst),
      'depart_to': showDate(tourDates.snd),
      if (meals.isNotEmpty) 'meals': meals.join(','),
      if (stars.isNotEmpty) 'stars': stars.join(','),
      if (hotels.isNotEmpty) 'hotels': hotels.join(','),
      if (cities.isNotEmpty) 'cities': cities.join(','),
    });
    final res = await _dio.get<Object>(uri);

    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      final value = data['value'] as Map<String, dynamic>;
      return TourModel.serialize(value);
    }
    return const [];
  }

  static Future<ActualizedPriceModel?> getActualizePrice({
    required TourModel tour,
    required bool showcase,
  }) async {
    if (!await Api.hasConnection()) {
      return null;
    }

    final uri = _makeUri('actualize_price', {
      'request_id': tour.requestId,
      'offer_id': tour.offerId,
      'source_id': tour.sourceId,
      'currency_alias': tour.costCurrency,
      'showcase': showcase,
    });
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
      final value = data['value'] as Map<String, dynamic>;
      final actualizePriceResult =
          value['ActualizePriceResult'] as Map<String, dynamic>;
      final actualizePriceResultData =
          actualizePriceResult['Data'] as Map<String, dynamic>;
      final result = actualizePriceResultData['data'] as List<dynamic>;
      return ActualizedPriceModel.serialize(
        showcase: showcase,
        tour: tour,
        data: result,
      );
    }
    return null;
  }

  static Future<bool> createLead({
    required String note,
  }) async {
    if (!await Api.hasConnection()) {
      return false;
    }

    final uri = _makeUri('create_lead', {'note': note});
    final res = await _dio.get<Object>(uri);
    final data = jsonDecode(res.data as String) as Map<String, dynamic>;

    if (data['kind'] == 'success') {
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
