import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:readmore/readmore.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/hotel_comments.route.dart';

class DescriptionWidget extends StatelessWidget {
  final DataModel data;

  const DescriptionWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: Api.getHotelDescription(
          hotelId: data.tour!.hotelId,
        ),
        initialData: 'Загрузка...',
        builder: (context, snapshot) {
          final data = (snapshot.data as String?) ?? '';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            width: double.infinity,
            child: data.isEmpty
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
                    data,
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
        },
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
            onTap: () => showHotelCommentsRoute(context: context, data: data),
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
