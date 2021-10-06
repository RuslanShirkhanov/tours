import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';
import 'package:hot_tours/search_tours/search_tours.section.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';

import 'package:hot_tours/select_tour/routes/form.route.dart';

void showNoSearchResultsRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) =>
            NoSearchResultsRoute(data: currentData!),
        transitionsBuilder: (context, fst, snd, child) {
          const begin = Offset(1.0, 0.0);
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

class NoSearchResultsRoute extends StatelessWidget {
  final DataModel data;

  const NoSearchResultsRoute({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
                backgroundColor: const Color(0xff2Eaeee),
                hasSectionIndicator: false,
                title: 'Результаты поиска',
                hasSubtitle: false,
                hasBackButton: true,
                hasLoadingIndicator: false,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: ListView(
                  children: <Widget>[
                    Text(
                      '${data.departCity!.name} - ${data.targetCountry!.name}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: const Color(0xff4d4948),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'ночей: ${data.nightsCount!.fst} - ${data.nightsCount!.snd}, '
                      'взрослых: ${data.peopleCount!.fst}, '
                      'детей: ${data.peopleCount!.snd}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0,
                        color: const Color(0xff4d4948),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    const Text(
                      'По вашим параметрам туры не найдены,\nпопробуйте поменять параметры',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0,
                        color: const Color(0xff0093dd),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: ListButtonWidget(
                        text: 'Поменять параметры',
                        onTap: () => showSearchToursSection(
                          context: context,
                          data: data,
                        ),
                      ),
                    ),
                    const SizedBox(height: 68.0),
                    const Text(
                      'или мы подберём тур\nпо вашим параметрам',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: const Color(0xff0093dd),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: ListButtonWidget(
                        text: 'Подобрать тур',
                        onTap: () => showFormRoute(
                          context: context,
                          data: data,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
