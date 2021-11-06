import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/star.model.dart';
import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/no_search_results.route.dart';
import 'package:hot_tours/search_tours/routes/search_results.route.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: NavBarWidget(
                hasBackButton: true,
                title: 'Загрузка',
                hasSectionIndicator: false,
                hasSubtitle: false,
                hasLoadingIndicator: false,
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
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${data.departCity!.name} → ${data.targetCountry!.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          '${data.tourDates.first.day}.${data.tourDates.first.month} - ${data.tourDates.last.day}.${data.tourDates.last.month}, ночей: ${data.nightsCount!.fst} - ${data.nightsCount!.snd}, взрослых: ${data.peopleCount!.fst}${data.peopleCount!.snd.gt(0) ? ', детей: ${data.peopleCount!.snd}' : ''}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 100.0),
                        const Text(
                          'Идёт поиск туров',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 24.0,
                            color: Color(0xff0093dd),
                          ),
                        ),
                        const SizedBox(height: 100.0),
                        const CircularProgressIndicator(),
                        // SizedBox(
                        //   width: 16 * 2 + 15 * 2 + 28,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: <Widget>[
                        //       Container(
                        //         width: 16.0,
                        //         height: 16.0,
                        //         decoration: const BoxDecoration(
                        //           color: Color(0xff2eaeee),
                        //           shape: BoxShape.circle,
                        //         ),
                        //       ),
                        //       Container(
                        //         width: 28.0,
                        //         height: 28.0,
                        //         decoration: const BoxDecoration(
                        //           color: Color(0xff2eaeee),
                        //           shape: BoxShape.circle,
                        //         ),
                        //       ),
                        //       Container(
                        //         width: 16.0,
                        //         height: 16.0,
                        //         decoration: const BoxDecoration(
                        //           color: Color(0xff2eaeee),
                        //           shape: BoxShape.circle,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
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
