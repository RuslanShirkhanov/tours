import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

import 'package:hot_tours/models/depart_city.model.dart';

class CommonDataModel {
  final DepartCityModel? departCity;

  const CommonDataModel({
    required this.departCity,
  });

  factory CommonDataModel.empty() => const CommonDataModel(departCity: null);
}

class CommonStorageModel {
  final CommonDataModel data;

  const CommonStorageModel(this.data);

  factory CommonStorageModel.empty() =>
      CommonStorageModel(CommonDataModel.empty());

  static CommonDataModel mix(
    CommonStorageModel storage,
    CommonDataModel data,
  ) =>
      CommonDataModel(
        departCity: storage.data.departCity,
      );

  static CommonStorageModel fromData(CommonDataModel data) =>
      CommonStorageModel(data);

  static CommonStorageModel serialize(Map<String, dynamic> data) =>
      CommonStorageModel(
        CommonDataModel(
          departCity: DepartCityModel.serialize(
            data['departCity']! as Map<String, dynamic>,
          ),
        ),
      );

  static Map<String, dynamic> deserialize(CommonStorageModel data) =>
      <String, dynamic>{
        'departCity': DepartCityModel.deserialize(
          data.data.departCity!,
        ),
      };
}

abstract class CommonStorageController {
  static Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  static Future<File> get _localFile async =>
      File('${await _localPath}/storage.json');

  static Future<CommonStorageModel> read() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final data = jsonDecode(contents) as Map<String, dynamic>;
      return CommonStorageModel.serialize(data);
    } catch (e) {
      return CommonStorageModel.empty();
    }
  }

  static Future write(CommonStorageModel data) async {
    final file = await _localFile;
    final contents = jsonEncode(CommonStorageModel.deserialize(data));
    return file.writeAsString(contents);
  }
}
