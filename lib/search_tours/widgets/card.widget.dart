import 'package:flutter/material.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/thousands.dart';

import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/widgets/image_widget.dart';
import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/select_tours/widgets/button.widget.dart';

import 'package:hot_tours/search_tours/routes/search_results.route.dart';

class CardWidget extends StatelessWidget {
  final List<TourModel> tours;
  final void Function() onTap;

  const CardWidget({
    Key? key,
    required this.tours,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 360.0,
          height: 320.0,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffd6d6d6)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            tours.first.hotelName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        ShownStarsWidget(data: tours.first.hotelStar),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      tours.first.targetCityName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                        color: Color(0xff7d7d7d),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: tours.first.photosCount.value == 0
                      ? blackPlug()
                      : NetworkImageWidget(
                          url: Api.makeImageUri(
                            hotelId: tours.first.hotelId,
                            imageNumber: const U(0),
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
                      const SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: FutureBuilder(
                              future: Api.getHotelDescription(
                                hotelId: tours.first.hotelId,
                              ),
                              initialData: 'Загрузка...',
                              builder: (context, snapshot) {
                                final data = (snapshot.data as String?) ?? '';
                                return Text(
                                  data.isEmpty
                                      ? 'Описание отеля временно отсутствует. Ведётся добавление информации.'
                                      : data,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonWidget(
                            isFlexible: true,
                            isActive: true,
                            text:
                                '${thousands(tours.min.cost)} ${tours.first.costCurrency.toUpperCase() == 'RUB' ? 'р.' : tours.first.costCurrency}',
                            onTap: onTap,
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            'за номер',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: Color(0xff7d7d7d),
                            ),
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
