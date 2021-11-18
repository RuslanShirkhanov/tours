import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/pair.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/select_many.route.dart';

void showSelectNightsCountRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectNightsCountRoute(
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

class SelectNightsCountRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectNightsCountRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ranges = [
      Pair(7, 11),
      Pair(12, 15),
      Pair(16, 21),
      Pair(22, 28),
    ];

    final initial = useState(
      <int>[
        if (data.nightsCount.isNotEmpty)
          ranges.indexOf(
            Pair(
              data.nightsCount.fst!.value,
              data.nightsCount.snd!.value,
            ),
          ),
      ],
    );

    return SelectManyRoute<Pair<int, int>>(
      title: 'Поиск туров',
      subtitle: 'Выберите количество ночей',
      values: ranges,
      initial: initial,
      isSingle: true,
      transform: (value) => '${value.fst} - ${value.snd} ночей',
      onContinue: (indices) => onContinue(
        data.setNightsCount(
          Pair(
            U(ranges[indices[0]].fst),
            U(ranges[indices[0]].snd),
          ),
        ),
      ),
    );
  }
}
