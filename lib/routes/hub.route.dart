import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/hot_tours/hot_tours.section.dart';
import 'package:hot_tours/search_tours/search_tours.section.dart';
import 'package:hot_tours/select_tour/select_tour.section.dart';
import 'package:hot_tours/contacts/contacts.section.dart';

void showHubRoute(
  BuildContext context, {
  bool removeUntil = false,
}) =>
    showRoute<Object?>(
      removeUntil: removeUntil,
      context: context,
      model: null,
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => HubRoute(),
        transitionsBuilder: (context, fst, snd, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: fst.drive(tween),
            child: child,
          );
        },
      ),
    );

class HubRoute extends StatelessWidget {
  const HubRoute({Key? key}) : super(key: key);

  Widget _buildButton({
    required String path,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        height: 70.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(3.0, 3.0),
              blurRadius: 10.0,
              color: Colors.black.withAlpha(50),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            if (path.isNotEmpty)
              SizedBox(
                width: 36.0,
                height: 36.0,
                child: SvgPicture.asset(path),
              ),
            if (path.isNotEmpty) const SizedBox(width: 20.0),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 22.0,
                color: const Color(0xff4d4948),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  _buildButton(
                    path: 'assets/fire.svg',
                    text: 'Горящие туры',
                    onTap: () => showHotToursSection(context: context),
                  ),
                  const SizedBox(height: 45.0),
                  _buildButton(
                    path: 'assets/search.svg',
                    text: 'Поиск туров',
                    onTap: () => showSearchToursSection(context: context),
                  ),
                  const SizedBox(height: 45.0),
                  _buildButton(
                    path: 'assets/select.svg',
                    text: 'Подобрать тур',
                    onTap: () => showSelectTourSection(context: context),
                  ),
                  const SizedBox(height: 45.0),
                  _buildButton(
                    path: 'assets/phone.svg',
                    text: 'Контакты',
                    onTap: () => showContactsRoute(context: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
