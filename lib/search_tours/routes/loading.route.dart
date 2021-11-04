import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/star.model.dart';
import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/no_search_results.route.dart';
import 'package:hot_tours/search_tours/routes/search_results.route.dart';

import 'package:hot_tours/widgets/header.widget.dart';

void showLoadingRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => LoadingRoute(data: currentData!),
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

class LoadingRoute extends HookWidget {
  final DataModel data;

  const LoadingRoute({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final stream = useState(Stream.periodic(
      const Duration(seconds: 1),
      (index) => index,
    ).take(110));

    final ticks = useStream(stream.value, initialData: 0);

    final tours = useState<List<TourModel>?>(null);

    useEffect(() {
      Api.getSeasonTours(
        cityFromId: data.departCity!.id,
        countryId: data.targetCountry!.id,
        peopleCount: data.peopleCount!,
        kidsAges: data.childrenAges,
        nightsCount: data.nightsCount!,
        cities: data.targetCities.map((city) => city.id).toList(),
        stars: data.hotelStars.isEmpty
            ? const []
            : StarModel.difference(selected: data.hotelStars)
                .map((star) => star.id)
                .toList(),
        hotels: data.hotels.map((hotel) => hotel.id).toList(),
        meals: data.meals.map((meal) => meal.id).toList(),
      ).then((value) {
        tours.value = value;
      });
    }, []);

    useEffect(() {
      if (tours.value != null) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          tours.value!.isEmpty
              ? showNoSearchResultsRoute(
                  context: context,
                  data: data,
                )
              : showSearchResultsRoute(
                  context: context,
                  data: data,
                  tours: tours.value!,
                );
        });
      }
    }, [tours.value]);

    // !!!
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
                hasBackButton: true,
                title: 'Загрузка',
                hasSectionIndicator: true,
                sectionsCount: const U<int>(120),
                sectionIndex: U<int>(ticks.data!),
                hasSubtitle: false,
                hasLoadingIndicator: true,
                isLoading: true,
                backgroundColor: const Color(0xff2eaeee),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      top: 60.0,
                      bottom: 20.0,
                    ),
                    child: Column(), // !!!
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
