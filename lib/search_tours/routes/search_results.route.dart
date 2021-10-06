import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/color.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/tour.model.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';
import 'package:hot_tours/select_tour/widgets/button.widget.dart';
import 'package:hot_tours/search_tours/routes/form.route.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/widgets/slider.widget.dart';
import 'package:hot_tours/widgets/image_widget.dart';

void showHotelCardRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => HotelCardRoute(data: data!),
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

class HotelCardRoute extends StatelessWidget {
  final DataModel data;

  const HotelCardRoute({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              hasSectionIndicator: false,
              title: 'Результаты поиска',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 6.0,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffd6d6d6),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        // HEADER
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                            left: 14.0,
                            right: 35.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data.tour!.hotelName.capitalized,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0,
                                          color: const Color(0xff4d4948),
                                        ),
                                      ),
                                      const SizedBox(width: 6.0),
                                      Container(
                                        width: 36.0,
                                        height: 18.0,
                                        decoration: BoxDecoration(
                                          color: fade(data.tour!.hotelRating),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.5),
                                          child: Center(
                                            child: Text(
                                              '${data.tour!.hotelRating}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    data.tour!.targetCityName,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10.0,
                                      color: const Color(0xff7d7d7d),
                                    ),
                                  ),
                                ],
                              ),
                              ShownStarsWidget(data: data.tour!.hotelStar),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        // SLIDER
                        SliderWidget(data: data.tour!),
                        const SizedBox(height: 15.0),
                        // DESCRIPTION
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          width: double.infinity,
                          child: Text(
                            data.tour!.hotelDesc,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.0,
                              color: const Color(0xff4d4948),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // MORE
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => launch(data.tour!.hotelDescUrl),
                                child: Container(
                                  width: 80.0,
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff5f5f5),
                                    border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xffc1c1c1),
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Center(
                                    child: const Text(
                                      'Больше',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        // DIVIDER
                        const Divider(
                          height: 13.0,
                          color: const Color(0xffe5e5e5),
                        ),
                        const SizedBox(height: 10.0),
                        // CHARS
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'В: ${data.tour!.targetCountryName}, из: ${data.tour!.departCityName}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: const Color(0xff4d4948),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Вылет: ${data.tour!.dateIn}, ночей: ${data.tour!.nightsCount}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: const Color(0xff4d4948),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Взрослых: ${data.tour!.adultsCount}, детей: ${data.tour!.childrenCount}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: const Color(0xff4d4948),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Апартаменты: ${data.tour!.mealTypeDesc.uncapitalized} (${data.tour!.mealType.capitalized})',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: const Color(0xff4d4948),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Питание: ${data.tour!.roomTypeDesc.uncapitalized} (${data.tour!.roomType.capitalized})',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: const Color(0xff4d4948),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35.0),
                        // BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonWidget(
                              isFlexible: true,
                              isActive: true,
                              text:
                                  '${data.tour!.cost} ${data.tour!.costCurrency}',
                              onTap: () =>
                                  showFormRoute(context: context, data: data),
                            ),
                          ],
                        ),
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

class HotelCardWidget extends StatelessWidget {
  final DataModel data;

  const HotelCardWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showHotelCardRoute(context: context, data: data),
      child: Container(
        width: 360.0,
        height: 300.0,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffd6d6d6)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: data.tour!.photosCount.value == 0
                      ? blackPlug()
                      : NetworkImageWidget(
                          url: Api.makeImageUri(
                            hotelId: data.tour!.hotelId,
                            imageNumber: U<int>(0),
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 17.0,
                  top: 13.0,
                  right: 23.0,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            child: Text(
                              data.tour!.hotelName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        ShownStarsWidget(data: data.tour!.hotelStar),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${data.tour!.targetCityName}, ${data.tour!.targetCountryName}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Вылет: ${data.tour!.dateIn}, количество ночей: ${data.tour!.nightsCount}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ButtonWidget(
                          isFlexible: true,
                          isActive: true,
                          text: '${data.tour!.cost} ${data.tour!.costCurrency}',
                          onTap: () =>
                              showHotelCardRoute(context: context, data: data),
                        ),
                      ],
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

class SearchResultsRoute extends StatelessWidget {
  final DataModel data;
  final List<TourModel> tours;

  const SearchResultsRoute({
    required this.data,
    required this.tours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              hasSectionIndicator: false,
              title: 'Результаты поиска',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: ListView(
                children: tours
                    .map((tour) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: HotelCardWidget(data: data.setTour(tour))))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}