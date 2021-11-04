import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/select_tours/models/data.model.dart';

import 'package:hot_tours/select_tours/routes/select_when.route.dart';
import 'package:hot_tours/select_tours/routes/select_many.route.dart';

void showSelectWhatRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectWhatRoute(
          data: currentData!,
          onContinue: (newData) => showSelectWhenRoute(
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

class SelectWhatRoute extends StatelessWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectWhatRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SelectManyRoute(
        isRequired: false,
        sectionIndex: data.sectionIndex,
        primaryText: 'Что для вас важно в отдыхе?',
        primaryData: const <String>[
          'Минимальная цена',
          'Всё включено',
          'Хороший отель',
          'С хорошим питанием',
          'Активный отдых',
          '1 береговая линия',
          'Песчаный пляж',
          'Без визы',
          'Раннее бронирование',
          'Горящий тур',
          'Отдых с детьми',
        ],
        isPrimarySingle: false,
        secondaryData: const <String>[],
        isSecondarySingle: true,
        hasAlternative: false,
        onContinue: (value) => onContinue(
          data.setWhat(value),
        ),
      );
}
