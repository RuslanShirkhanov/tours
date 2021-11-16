import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';
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
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.pop(context);
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
                          () {
                                final date = data.tourDates.first;
                                final day = U(date.day);
                                final month = U(date.month);
                                return '$day ${declineWord(Date.monthToString(month.value), day)}';
                              }() +
                              ' - ' +
                              () {
                                final date = data.tourDates.last;
                                final day = U(date.day);
                                final month = U(date.month);
                                return '$day ${declineWord(Date.monthToString(month.value), day)}';
                              }() +
                              ', ' +
                              () {
                                final nights = data.nightsCount!;
                                return '${nights.fst} - ${nights.snd} ночей';
                              }() +
                              ', ' +
                              () {
                                final people = data.peopleCount!;
                                if (people.snd.eq(0)) {
                                  return '${people.fst} ${declineWord('взрослый', people.fst)}';
                                }
                                return '${people.fst} ${declineWord('взрослый', people.fst).substring(0, 3)} + ${people.snd} ${declineWord('ребёнок', people.snd).substring(0, 3)}';
                              }(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
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
