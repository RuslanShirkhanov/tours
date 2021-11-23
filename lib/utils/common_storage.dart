import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/models/depart_city.model.dart';

enum CDK { departCity, targetCountry }

extension on CDK {
  String get show {
    switch (this) {
      case CDK.departCity:
        return 'depart_city';
      case CDK.targetCountry:
        return 'target_country';
    }
  }
}

class CDM extends Equatable {
  final DepartCityModel? departCity;
  final CountryModel? targetCountry;

  const CDM({
    required this.departCity,
    required this.targetCountry,
  });

  @override
  List<Object?> get props => [departCity, targetCountry];

  CDM setDepartCity(DepartCityModel? value) => CDM(
        departCity: value,
        targetCountry: targetCountry,
      );

  CDM setTargetCountry(CountryModel? value) => CDM(
        departCity: departCity,
        targetCountry: value,
      );

  factory CDM.empty() => const CDM(
        departCity: null,
        targetCountry: null,
      );

  static CDM serialize(Map<String, dynamic> data) => CDM(
        departCity: () {
          final value = data[CDK.departCity.show] as Map<String, dynamic>?;
          return value == null ? null : DepartCityModel.serialize(value);
        }(),
        targetCountry: () {
          final value = data[CDK.targetCountry.show] as Map<String, dynamic>?;
          return value == null ? null : CountryModel.serialize(value);
        }(),
      );

  static Map<String, dynamic> deserialize(CDM data) => <String, dynamic>{
        CDK.departCity.show: data.departCity == null
            ? null
            : DepartCityModel.deserialize(
                data.departCity!,
              ),
        CDK.targetCountry.show: data.targetCountry == null
            ? null
            : CountryModel.deserialize(
                data.targetCountry!,
              ),
      };
}

abstract class CommonStorageController {
  static var _model = CDM.empty();
  static var _isInitialized = false;

  static void _checkIsInitialized() {
    if (!_isInitialized) {
      throw 'CommonStorageController is not initialized';
    }
  }

  static Future<void> init() async {
    if (!_isInitialized) {
      _model = await _read();
      _isInitialized = true;
    }
  }

  static set data(CDM value) {
    _model = value;
    _isInitialized = true;
    _write(_model);
  }

  static CDM get data {
    _checkIsInitialized();
    return _model;
  }

  static T setValue<T>({
    required CDK key,
    required T value,
  }) {
    switch (key) {
      case CDK.departCity:
        {
          CommonStorageController.data = CommonStorageController.data
              .setDepartCity(value as DepartCityModel);
          return value;
        }
      case CDK.targetCountry:
        {
          CommonStorageController.data = CommonStorageController.data
              .setTargetCountry(value as CountryModel);
          return value;
        }
    }
  }

  static T? getValue<T>({
    required CDK key,
    required T? initial,
  }) {
    switch (key) {
      case CDK.departCity:
        {
          final value = (_model.departCity as T?) ?? initial;
          CommonStorageController.data = CommonStorageController.data
              .setDepartCity(value as DepartCityModel?);
          return value;
        }
      case CDK.targetCountry:
        {
          final value = (_model.targetCountry as T?) ?? initial;
          CommonStorageController.data = CommonStorageController.data
              .setTargetCountry(value as CountryModel?);
          return value;
        }
    }
  }

  static Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  static Future<File> get _localFile async =>
      File('${await _localPath}/storage.json');

  static Future<CDM> _read() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final data = jsonDecode(contents) as Map<String, dynamic>;
      CommonStorageController.data = CDM.serialize(data);
      return CommonStorageController.data;
    } catch (e) {
      CommonStorageController.data = CDM.empty();
      return CommonStorageController.data;
    }
  }

  static Future<void> _write(CDM data) async {
    final file = await _localFile;
    final contents = jsonEncode(CDM.deserialize(data));
    await file.writeAsString(contents);
  }
}
