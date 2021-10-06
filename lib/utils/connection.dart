import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension on ConnectivityResult? {
  ConnectivityResult get transform {
    switch (this) {
      case ConnectivityResult.none:
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        return this!;
      default:
        return ConnectivityResult.none;
    }
  }
}

extension Check on ConnectivityResult? {
  bool get isNone => transform == ConnectivityResult.none;
  bool get isNotNone => transform != ConnectivityResult.none;
}

@immutable
abstract class ConnectionUtil {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  const ConnectionUtil();

  static late final Connectivity _instance;
  // ignore: prefer_const_declarations
  static late final bool _isInitialized = false;
  static late var _lastValue = ConnectivityResult.none;

  static Future<void> init() async {
    if (!_isInitialized) {
      _instance = Connectivity();
      try {
        _lastValue = (await _instance.checkConnectivity()).transform;
      } on PlatformException catch (_) {
        _lastValue = ConnectivityResult.none;
        await init();
      }
      _lastValue = _lastValue;
    }
  }

  static Connectivity get getInstance => _instance; // DELETE LATER

  static ValueNotifier<ConnectivityResult> useConnection() {
    final state = useState(_lastValue);
    useEffect(() {
      final subscription = _instance.onConnectivityChanged
          .listen((event) => state.value = event.transform);
      return () => subscription.cancel();
    }, []);
    return state;
  }

  static ValueNotifier<ConnectivityResult> useConnectionAlert() {
    final state = useState(_lastValue);
    useEffect(() {
      final subscription = _instance.onConnectivityChanged.listen((event) {
        state.value = event.transform;
        _showConnectionAlert(state.value);
      });
      return () => subscription.cancel();
    }, []);
    return state;
  }

  static void _showSnackBar(
    String text,
  ) =>
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      );

  static void _showConnectionAlert(
    ConnectivityResult connectivityResult,
  ) =>
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        if (connectivityResult.isNone) {
          _showSnackBar('Отсутствует подключение к сети');
        } else if (_lastValue.isNone) {
          _showSnackBar('Подключение к сети восстановлено');
        }
        _lastValue = connectivityResult;
      });
}
