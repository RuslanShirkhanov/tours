import 'package:flutter/material.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/string.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

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
                color: Color(0xff2eaeee),
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
