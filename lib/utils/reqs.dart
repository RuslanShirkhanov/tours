import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:hot_tours/models/unsigned.dart';

import 'package:path_provider/path_provider.dart';

enum ReqKind { hot, search, select, callback }

ReqKind serializeReqKind(String data) {
  switch (data) {
    case 'hot':
      return ReqKind.hot;
    case 'search':
      return ReqKind.search;
    case 'select':
      return ReqKind.select;
    case 'callback':
      return ReqKind.callback;
    default:
      throw TypeError();
  }
}

String deserializeReqKind(ReqKind data) {
  switch (data) {
    case ReqKind.hot:
      return 'hot';
    case ReqKind.search:
      return 'search';
    case ReqKind.select:
      return 'select';
    case ReqKind.callback:
      return 'callback';
    default:
      throw TypeError();
  }
}

class ReqsModel {
  final Map<ReqKind, DateTime?> data;

  const ReqsModel(this.data);

  factory ReqsModel.empty() => const ReqsModel({
        ReqKind.hot: null,
        ReqKind.search: null,
        ReqKind.select: null,
        ReqKind.callback: null,
      });

  ReqsModel setReq(ReqKind kind) => ReqsModel(
        data.map(
          (key, value) => MapEntry(
            key,
            key == kind ? DateTime.now() : value,
          ),
        ),
      );

  DateTime? getReq(ReqKind kind) => data[kind];

  bool canSetReq(ReqKind kind) {
    final value = getReq(kind);
    return value == null
        ? true
        : DateTime.now().difference(value).inMinutes >=
            ReqsController.rollback.value;
  }

  Duration howLong(ReqKind kind) {
    final value = getReq(kind);
    return value == null ? const Duration() : DateTime.now().difference(value);
  }
}

abstract class ReqsController {
  static var _model = ReqsModel.empty();
  static var _isInitialized = false;

  static void _checkIsInitialized() {
    if (!_isInitialized) {
      throw 'ReqsController is not initialized';
    }
  }

  static Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  static Future<File> get _localFile async =>
      File('${await _localPath}/requests.json');

  static Future<ReqsModel> _read() async {
    if (kIsWeb) {
      return ReqsModel.empty();
    }
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final data = (jsonDecode(contents) as Map<String, String>).map(
        (key, value) =>
            MapEntry(serializeReqKind(key), DateTime.tryParse(value)),
      );
      return ReqsModel(data);
    } catch (e) {
      return ReqsModel.empty();
    }
  }

  static Future _write() async {
    if (kIsWeb) {
      return;
    }
    final file = await _localFile;
    final contents = jsonEncode(_model.data.map(
      (key, value) => MapEntry(
        deserializeReqKind(key),
        value.toString(),
      ),
    ));
    return file.writeAsString(contents);
  }

  static Future<void> _update(ReqsModel data) async {
    _checkIsInitialized();
    _model = data;
    return _write();
  }

  static Future<void> init() async {
    if (!_isInitialized) {
      _model = await _read();
      _isInitialized = true;
    }
  }

  static Future<void> setReq(ReqKind kind) async {
    _checkIsInitialized();
    await _update(_model.setReq(kind));
  }

  static Future<DateTime?> getReq(ReqKind kind) async {
    _checkIsInitialized();
    return _model.getReq(kind);
  }

  static const rollback = U(15);

  static bool canSetReq(ReqKind kind) => _model.canSetReq(kind);

  static Duration howLong(ReqKind kind) => _model.howLong(kind);
}
