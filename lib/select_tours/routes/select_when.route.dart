import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/select_tours/models/data.model.dart';

import 'package:hot_tours/select_tours/routes/select_how_long.route.dart';
import 'package:hot_tours/select_tours/routes/select_many.route.dart';

void showSelectWhenRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectWhenRoute(
          data: currentData!,
          onContinue: (newData) => showSelectHowLongRoute(
            context: context,
            data: newData,
          ),
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

class SelectWhenRoute extends StatelessWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectWhenRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SelectManyRoute(
        sectionIndex: data.sectionIndex,
        primaryText: 'Когда хотите полететь?',
        primaryData: const <String>[
          'Чем быстрее, тем лучше',
          'Ближайшие 2 недели',
          'Ближайший месяц',
        ],
        isPrimarySingle: true,
        secondaryText: 'или выберите месяц',
        secondaryData: const <String>[
          'Январь',
          'Февраль',
          'Март',
          'Апрель',
          'Май',
          'Июнь',
          'Июль',
          'Август',
          'Сентябрь',
          'Октябрь',
          'Ноябрь',
          'Декабрь',
        ],
        isSecondarySingle: false,
        onContinue: (value) => onContinue(
          data.setWhen(value),
        ),
      );
}
