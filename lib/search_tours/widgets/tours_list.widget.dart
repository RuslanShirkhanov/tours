import 'package:flutter/material.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/thousands.dart';

import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/select_tours/widgets/button.widget.dart';

import 'package:hot_tours/search_tours/routes/information.route.dart';

class ToursListWidget extends StatelessWidget {
  final DataModel data;
  final List<TourModel> tours;

  const ToursListWidget({
    Key? key,
    required this.data,
    required this.tours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tours.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Text(
                  () {
                        final date = Date.parseDate(tours[index].dateIn);
                        final day = U(date.day);
                        final month = U(date.month);
                        final nights = tours[index].nightsCount;
                        return '$day ${declineWord(Date.monthToString(month.value), day)}, $nights ${declineWord('ночь', nights)}';
                      }() +
                      '\n' +
                      () {
                        final adults = tours[index].adultsCount;
                        final children = tours[index].childrenCount;
                        if (children.eq(0)) {
                          return '$adults ${declineWord('взрослый', adults)}';
                        }
                        return '$adults ${declineWord('взрослый', adults)}, $children ${declineWord('ребёнок', children)}';
                      }() +
                      '\n' +
                      (tours[index].roomTypeDesc.length > 25
                          ? tours[index]
                                  .roomTypeDesc
                                  .capitalized
                                  .substring(0, 25) +
                              '...'
                          : tours[index].roomTypeDesc.capitalized) +
                      '\n' +
                      tours[index].mealTypeDesc.capitalized,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 12.0),
                ),
              ),
              const SizedBox(width: 10.0),
              Flexible(
                flex: 2,
                child: ButtonWidget(
                  isFlexible: true,
                  text:
                      '${thousands(tours[index].cost)} ${tours[index].costCurrency.toUpperCase() == 'RUB' ? 'р.' : tours[index].costCurrency}',
                  isActive: true,
                  onTap: () => showInformationRoute(
                    context: context,
                    data: data.setTour(tours[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
        separatorBuilder: (_, __) => const Divider(),
      );
}
