import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/meal.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/select_many.route.dart';

void showSelectMealsRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectMealsRoute(
          data: currentData!,
          onContinue: (newData) {
            onContinue(newData);
            Navigator.of(context).pop();
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

class SelectMealsRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectMealsRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meals = MealModel.getMeals();

    final initial = useState(
      data.meals.isEmpty ? <int>[] : data.meals.map(meals.indexOf).toList(),
    );

    return SelectManyRoute<MealModel>(
      title: 'Поиск туров',
      subtitle: 'Выберите питание',
      values: meals,
      initial: initial,
      isSingle: false,
      transform: mealToString,
      onContinue: (indices) => onContinue(
        data.setMeals(indices.map((index) => meals[index]).toList()),
      ),
    );
  }
}
