import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/connection.dart';
import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/map_to_list.dart';
import 'package:hot_tours/utils/sorted.dart';

import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/select_tours/models/data.model.dart';

import 'package:hot_tours/select_tours/routes/select_many.route.dart';
import 'package:hot_tours/select_tours/routes/select_what.route.dart';

void showSelectWhereRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectWhereRoute(
          data: currentData!,
          onContinue: (newData) => showSelectWhatRoute(
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

class SelectWhereRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectWhereRoute({
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

    final targetCountries = useState(const <CountryModel>[]);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (connection.value.isNotNone) {
        Api.getCountries(
          townFromId: data.departCity!.id,
          showcase: false,
        ).then((value) {
          targetCountries.value =
              value.sorted((a, b) => a.name.compareTo(b.name));
          setState<bool>(isLoading)(false);
        });
      }
    }, [connection.value]);

    return SelectManyRoute(
      isRequired: false,
      sectionIndex: data.sectionIndex,
      isLoading: isLoading.value,
      primaryText: 'Где хотите отдохнуть?',
      primaryData: targetCountries.value.mapToList((c, _) => c.name),
      isPrimarySingle: true,
      secondaryData: const <String>[],
      isSecondarySingle: true,
      hasAlternative: false,
      onContinue: (value) => onContinue(
        data.setTargetCountries(value),
      ),
    );
  }
}
