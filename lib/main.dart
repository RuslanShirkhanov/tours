import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/connection.dart';

import 'package:hot_tours/routes/preloader.route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConnectionUtil.init();
  runApp(const Application());
}

class Application extends HookWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectionUtil.useConnectionAlert();
    return MaterialApp(
      scaffoldMessengerKey: ConnectionUtil.scaffoldMessengerKey,
      home: const PreloaderRoute(),
    );
  }
}
