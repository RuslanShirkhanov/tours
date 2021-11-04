import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/select_tours/models/data.model.dart';

import 'package:hot_tours/select_tours/routes/form.route.dart';
import 'package:hot_tours/select_tours/routes/select_many.route.dart';

void showSelectHowLongRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectHowLongRoute(
          data: currentData!,
          onContinue: (newData) => showFormRoute(
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

class SelectHowLongRoute extends StatelessWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectHowLongRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SelectManyRoute(
        isRequired: false,
        sectionIndex: data.sectionIndex,
        primaryText: 'Сколько примерно\nпланируете отдыхать?',
        primaryData: const <String>[
          '3 дня',
          '5 дней',
          '7 дней',
          '9 дней',
          '11 дней',
          '13 дней',
          '15 дней',
          '17 дней',
          '19 дней',
          '21 день',
          '25 дней',
          '30 дней',
        ],
        isPrimarySingle: true,
        secondaryData: const <String>[],
        isSecondarySingle: true,
        hasAlternative: false,
        onContinue: (value) => onContinue(
          data.setHowLong(value),
        ),
      );
}
