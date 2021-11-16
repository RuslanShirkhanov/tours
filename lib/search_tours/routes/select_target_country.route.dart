import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/connection.dart';

import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/checkbox.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';

void showSelectTargetCountryRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectTargetCountryRoute(
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

class SelectTargetCountryRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectTargetCountryRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final connection = ConnectionUtil.useConnection();

    final scrollController = useScrollController();

    final isLoading = useState(false);

    final isVisa = useState(true);

    final initialData = useState(<CountryModel>[]);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (connection.value.isNotNone) {
        Api.getCountries(
          townFromId: data.departCity!.id,
          showcase: false,
        ).then((value) {
          initialData.value = value.sorted((a, b) => a.name.compareTo(b.name));
          setState<bool>(isLoading)(false);
        });
      }
    }, [connection.value]);

    final targetCountries = useMemoized(
      () => isVisa.value
          ? initialData.value
          : initialData.value.where((c) => !c.isVisa).toList(),
      [initialData.value, isVisa.value],
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Поиск туров',
              subtitle: 'Выберите страну',
              hasSubtitle: true,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: true,
              isLoading: isLoading.value,
            ),
            const SizedBox(height: 15.0),
            CheckboxWidget(
              isActive: !isVisa.value,
              text: 'Без визы',
              onToggle: (isActive) => isVisa.value = !isActive,
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 50.0,
                  ),
                  itemCount: targetCountries.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: ListButtonWidget(
                      text: targetCountries[index].name,
                      onTap: () => onContinue(
                        data.setTargetCountry(targetCountries[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
