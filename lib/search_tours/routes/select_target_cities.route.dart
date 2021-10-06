import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/connection.dart';
import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/sorted.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/models/city.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/search_tours/routes/select_many.route.dart';

void showSelectTargetCitiesRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectTargetCitiesRoute(
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

class SelectTargetCitiesRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectTargetCitiesRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final connection = ConnectionUtil.useConnection();

    final isLoading = useState(false);

    final targetCities = useState(<CityModel>[]);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (connection.value.isNotNone)
        Api.getCities(countryId: data.targetCountry!.id).then((value) {
          targetCities.value = value.sorted((a, b) => a.name.compareTo(b.name));

          setState<bool>(isLoading)(false);
        });
    }, [connection.value]);

    return SelectManyRoute<CityModel>(
      hasLoadingIndicator: true,
      isLoading: isLoading.value,
      title: 'Поиск туров',
      subtitle: 'Выберите курорт / регион',
      primaryData: [],
      isPrimarySingle: true,
      secondaryData: targetCities.value,
      isSecondarySingle: false,
      transform: (city) => city.name,
      onContinue: (indices) => onContinue(
        data.setTargetCities(
          indices.map((index) => targetCities.value[index]).toList(),
        ),
      ),
    );
  }
}
