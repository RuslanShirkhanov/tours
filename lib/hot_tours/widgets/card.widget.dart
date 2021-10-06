import 'package:flutter/material.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/hot_tours/models/data.model.dart';
import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/hot_tours/routes/card.route.dart';
import 'package:hot_tours/widgets/image_widget.dart';

import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/hot_tours/widgets/button.widget.dart';

class CardWidget extends StatelessWidget {
  final DataModel data;

  const CardWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCardRoute(context: context, data: data),
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
                          text: '${data.tour!.cost} ${data.tour!.costCurrency}',
                          onTap: () =>
                              showCardRoute(context: context, data: data),
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