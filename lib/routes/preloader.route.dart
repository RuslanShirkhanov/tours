import 'package:flutter/material.dart';

import 'package:hot_tours/utils/reqs.dart';

import 'package:hot_tours/routes/hub.route.dart';

class PreloaderRoute extends StatelessWidget {
  const PreloaderRoute({Key? key}) : super(key: key);

  Future<void> navigate(BuildContext context) async {
    if (!Navigator.of(context).canPop()) {
      await ReqsController.init();
      await Future.delayed(
        const Duration(milliseconds: 750),
        () => showHubRoute(context, removeUntil: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => navigate(context));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/preloader.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: const Padding(
                padding: const EdgeInsets.only(bottom: 130.0),
                child: const Text(
                  'Горящие туры',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 30.0,
                    color: const Color(0xff4d4948),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
