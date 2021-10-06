import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:hot_tours/utils/color.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/hot_tours/models/data.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/widgets/slider.widget.dart';
import 'package:hot_tours/hot_tours/widgets/button.widget.dart';

import 'package:hot_tours/hot_tours/routes/form.route.dart';

void showCardRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => CardRoute(data: currentData!),
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

class CardRoute extends StatelessWidget {
  final DataModel data;

  const CardRoute({
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
              title: 'Горящие туры',
              hasSubtitle: false,
              backgroundColor: const Color(0xffdc2323),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
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
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.5),
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
                                'Откуда: ${data.tour!.departCityName}, куда: ${data.tour!.targetCountryName}, ${data.tour!.targetCityName}',
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