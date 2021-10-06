import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/select_tour/models/data.model.dart';

import 'package:hot_tours/select_tour/routes/form.route.dart';
import 'package:hot_tours/select_tour/routes/select_many.route.dart';

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
  Widget build(BuildContext context) {
    return SelectManyRoute(
      sectionIndex: data.sectionIndex,
      primaryText: 'Сколько примерно\nпланируете отдыхать?',
      primaryData: const <String>[
        '5 дней',
        '1 неделю',
        '10 дней',
        '2 недели',
        '3 недели',
        '1 месяц',
        'Предложите варианты',
      ],
      isPrimarySingle: true,
      secondaryData: const <String>[],
      isSecondarySingle: true,
      onContinue: (value) => onContinue(
        data.setHowLong(value),
      ),
    );
  }
}
