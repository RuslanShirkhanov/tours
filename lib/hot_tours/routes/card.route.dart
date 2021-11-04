import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hot_tours/utils/color.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/thousands.dart';

import 'package:hot_tours/models/unsigned.dart';
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

class CardRoute extends HookWidget {
  final DataModel data;

  const CardRoute({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              hasSectionIndicator: false,
              title: 'Информация о туре',
              hasSubtitle: false,
              backgroundColor: const Color(0xffdc2323),
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
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          data.tour!.hotelName.capitalized,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18.0,
                                            color: Color(0xff4d4948),
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
                                              padding: const EdgeInsets.only(
                                                  top: 1.5),
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
                                        fontSize: 12.0,
                                        color: Color(0xff7d7d7d),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            width: double.infinity,
                            child: Text(
                              data.tour!.hotelDesc.trim().isNotEmpty
                                  ? data.tour!.hotelDesc.trim()
                                  : 'Описание отеля временно отсутствует.',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                                color: Color(0xff4d4948),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // MORE
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                                        color: const Color(0xffc1c1c1),
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Больше',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
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
                            color: Color(0xffe5e5e5),
                          ),
                          const SizedBox(height: 10.0),
                          // CHARS
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${data.tour!.departCityName} → ${data.tour!.targetCountryName}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                    color: Color(0xffdc2323),
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  'Вылет - ${data.tour!.dateIn}, ночей - ${data.tour!.nightsCount}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                    color: Color(0xff4d4948),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  'Взрослых - ${data.tour!.adultsCount}${data.tour!.childrenCount > const U(0) ? ', детей - ${data.tour!.childrenCount}' : ''}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                    color: Color(0xff4d4948),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  '${data.tour!.roomTypeDesc.capitalized} (${data.tour!.roomType.capitalized})',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                    color: Color(0xff4d4948),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  '${data.tour!.mealTypeDesc.capitalized} (${data.tour!.mealType.capitalized})',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                    color: Color(0xff4d4948),
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                const Text(
                                  'В стоимость входит: авиаперелёт, проживание в отеле,\nмедицинская страховка, трансфер.',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 11.0,
                                    color: Color(0xff7d7d7d),
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
                              const Text(
                                'Купить',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Color(0xff7d7d7d),
                                ),
                              ),
                              const SizedBox(width: 13.0),
                              ButtonWidget(
                                text:
                                    '${thousands(data.tour!.cost)} ${data.tour!.costCurrency.toUpperCase() == 'RUB' ? 'р.' : data.tour!.costCurrency}',
                                onTap: () =>
                                    showFormRoute(context: context, data: data),
                              ),
                              const SizedBox(width: 13.0),
                              const Text(
                                'Купить',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
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
