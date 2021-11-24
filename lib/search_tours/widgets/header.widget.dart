import 'package:flutter/material.dart';

import 'package:hot_tours/utils/color.dart';
import 'package:hot_tours/utils/string.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/shown_stars.widget.dart';

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
          right: 14.0,
          bottom: 8.0,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    data.tour!.hotelName.capitalized,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      color: Color(0xff4d4948),
                    ),
                  ),
                ),
                SizedBox(
                  width: 36.0,
                  height: 18.0,
                  child: data.tour!.hotelRating == null
                      ? const SizedBox()
                      : Container(
                          decoration: BoxDecoration(
                            color: fade(data.tour!.hotelRating!),
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
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                ShownStarsWidget(data: data.tour!.hotelStar),
              ],
            ),
          ],
        ),
      );
}
