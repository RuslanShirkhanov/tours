import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/narrow.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/search_tours/widgets/card.widget.dart';
import 'package:hot_tours/select_tours/widgets/button.widget.dart';

import 'package:hot_tours/search_tours/routes/card.route.dart';
import 'package:hot_tours/select_tours/routes/form.route.dart'
    as select_tours_from_route;

extension Min on List<TourModel> {
  TourModel minF(TourModel a, TourModel b) => a.cost <= b.cost ? a : b;
  TourModel get min => reduce(minF);
}

void showSearchResultsRoute({
  required BuildContext context,
  required DataModel data,
  required List<TourModel> tours,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SearchResultsRoute(
          data: currentData!,
          tours: tours,
        ),
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

class SearchResultsRoute extends HookWidget {
  final DataModel data;
  final List<TourModel> tours;

  const SearchResultsRoute({
    Key? key,
    required this.data,
    required this.tours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final _tours = tours
        .sorted((a, b) => a.hotelName.compareTo(b.hotelName))
        .narrow((a, b) => a.hotelName == b.hotelName)
        .sorted((a, b) => a.min.cost.value.compareTo(b.min.cost.value));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Результаты поиска',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: ListView(
                  controller: scrollController,
                  children: [
                    ..._tours
                        .map((collection) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CardWidget(
                                tours: collection,
                                onTap: () => showCardRoute(
                                  context: context,
                                  data: data,
                                  tours: collection,
                                ),
                              ),
                            ))
                        .toList(),
                    const Divider(),
                    const SizedBox(height: 30.0),
                    Text(
                      'Подберем тур с лучшими условиями'
                      '\n${data.departCity!.name} → ${data.targetCountry!.name}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonWidget(
                          isFlexible: true,
                          isActive: true,
                          text: 'Подобрать тур',
                          onTap: () => select_tours_from_route.showFormRoute(
                            context: context,
                            data: data,
                          ),
                          borderColor: const Color(0xffeba627),
                          backgroundColor: const Color(0xffeba627),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
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
