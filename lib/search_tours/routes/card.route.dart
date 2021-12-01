import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/widgets/description.widget.dart';
import 'package:hot_tours/search_tours/widgets/header.widget.dart';
import 'package:hot_tours/utils/sorted.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/slider.widget.dart';
import 'package:hot_tours/search_tours/widgets/tours_list.widget.dart';

void showCardRoute({
  required BuildContext context,
  required DataModel data,
  required List<TourModel> tours,
}) =>
    showRoute<Object?>(
      context: context,
      model: null,
      builder: (_) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => CardRoute(data: data, tours: tours),
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

class CardRoute extends HookWidget {
  final DataModel data;
  final List<TourModel> tours;

  const CardRoute({
    Key? key,
    required this.data,
    required this.tours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Выберите тур',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffd6d6d6),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          HeaderWidget(data: data.setTour(tours.first)),
                          const SizedBox(height: 10.0),
                          SliderWidget(tour: tours.first),
                          const SizedBox(height: 15.0),
                          DescriptionWidget(data: data.setTour(tours.first)),
                          const SizedBox(height: 15.0),
                          DescriptionButtonsWidget(
                              data: data.setTour(tours.first)),
                          const SizedBox(height: 20.0),
                          Container(
                            color: const Color(0xffeba627),
                            height: 36.0,
                            child: const Center(
                              child: Text(
                                'Туры в этот отель',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ToursListWidget(
                            data: data,
                            tours: tours.sorted(
                              (a, b) => a.cost.value.compareTo(b.cost.value),
                            ),
                          ),
                        ],
                      ),
                    ),
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
