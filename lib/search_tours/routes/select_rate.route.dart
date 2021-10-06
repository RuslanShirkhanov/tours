import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/select_many.route.dart';

void showSelectRateRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectRateRoute(
          data: currentData!,
          onContinue: (newData) {
            Navigator.of(context).pop();
            onContinue(newData);
          },
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

class SelectRateRoute extends StatelessWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectRateRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rates =
        [4.5, 4.0, 3.5, 3.0, 1.5].map((rate) => U<double>(rate * 2.0)).toList();

    return SelectManyRoute<U<double>>(
      title: 'Поиск туров',
      subtitle: 'Выберите рейтинг отеля',
      primaryData: rates,
      isPrimarySingle: true,
      secondaryData: const [],
      isSecondarySingle: true,
      transform: rateToString,
      onContinue: (indices) => onContinue(
        data.setRate(rates[indices[0]]),
      ),
    );
  }
}

String rateToString(U<double> rate) {
  late String result;
  switch ((rate.value * 10).round()) {
    case 9 * 10:
      result = 'Превосходно';
      break;
    case 8 * 10:
      result = 'Очень хорошо';
      break;
    case 7 * 10:
      result = 'Хорошо';
      break;
    case 6 * 10:
      result = 'Нормально';
      break;
    case 3 * 10:
      result = 'Плохо';
      break;
    default:
      result = '';
  }
  return result + ' ${rate.value}+';
}
