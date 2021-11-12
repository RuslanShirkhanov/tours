import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readmore/readmore.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/color.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/thousands.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/hot_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/widgets/slider.widget.dart';
import 'package:hot_tours/hot_tours/widgets/button.widget.dart';

import 'package:hot_tours/hot_tours/routes/hotel_comments.route.dart';
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
            NavBarWidget(
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
                          HeaderWidget(data: data),
                          const SizedBox(height: 10.0),
                          SliderWidget(tour: data.tour!),
                          const SizedBox(height: 15.0),
                          DescriptionWidget(data: data),
                          const SizedBox(height: 15.0),
                          DescriptionButtonsWidget(data: data),
                          const SizedBox(height: 15.0),
                          const Divider(
                            height: 15.0,
                            color: Color(0xffe5e5e5),
                          ),
                          const SizedBox(height: 10.0),
                          ParametersWidget(data: data),
                          const SizedBox(height: 35.0),
                          BuyButtonWidget(data: data),
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

class ParametersWidget extends StatelessWidget {
  final DataModel data;

  const ParametersWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
              () {
                final date = Date.parseDate(data.tour!.dateIn);
                final day = U(date.day);
                final month = U(date.month);
                final nights = data.tour!.nightsCount;
                return 'Вылет $day ${declineWord(Date.monthToString(month.value), day)}, на $nights ${declineWord('ночь', nights)}';
              }(),
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
              () {
                final adults = data.tour!.adultsCount;
                final children = data.tour!.childrenCount;
                if (children.eq(0)) {
                  return '$adults ${declineWord('взрослый', adults)}';
                }
                return '$adults ${declineWord('взрослый', adults)}, $children ${declineWord('ребёнок', children)}';
              }(),
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
      );
}

class BuyButtonWidget extends StatelessWidget {
  final DataModel data;

  const BuyButtonWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
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
            onTap: () => showFormRoute(context: context, data: data),
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
      );
}

class HeaderWidget extends StatelessWidget {
  final DataModel data;

  const HeaderWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          left: 14.0,
          right: 35.0,
          bottom: 8.0,
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
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1.5),
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
      );
}

class DescriptionButtonsWidget extends StatelessWidget {
  final DataModel data;

  const DescriptionButtonsWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          DescriptionButtonWidget(
            text: 'Больше',
            onTap: () => launch(data.tour!.hotelDescUrl),
          ),
          const Spacer(),
          DescriptionButtonWidget(
            text: 'Отзывы',
            onTap: () => showHotelCommentsRoute(
              context: context,
              data: data,
            ),
          ),
          const Spacer(),
        ],
      );
}

class DescriptionButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DescriptionButtonWidget({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
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
          child: Center(
            child: Text(
              text,
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
      );
}

class DescriptionWidget extends StatelessWidget {
  final DataModel data;

  const DescriptionWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        width: double.infinity,
        child: data.tour!.hotelDesc.trim().isEmpty
            ? const Text(
                'Описание отеля временно отсутствует.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: Color(0xff4d4948),
                ),
              )
            : ReadMoreText(
                data.tour!.hotelDesc.trim(),
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Показать больше',
                trimExpandedText: 'Показать меньше',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: Color(0xff4d4948),
                ),
                moreStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: Color(0xff2eaeee),
                ),
                lessStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: Color(0xff2eaeee),
                ),
              ),
      );
}
