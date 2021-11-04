import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/country.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/checkbox.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';

void showSelectTargetCountryRoute({
  required BuildContext context,
  required List<CountryModel> data,
  required void Function(CountryModel) onSelect,
}) =>
    showRoute<List<CountryModel>>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectTargetCountryRoute(
          data: currentData!,
          onSelect: (country) {
            Navigator.of(context).pop();
            onSelect(country);
          },
        ),
        transitionsBuilder: (context, fst, snd, child) {
          const begin = Offset(0.0, 1.0);
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
  final List<CountryModel> data;
  final void Function(CountryModel) onSelect;

  const SelectTargetCountryRoute({
    Key? key,
    required this.data,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVisa = useState(false);

    final countries = useMemoized(
      () => data.where((c) => c.isVisa == isVisa.value).toList(),
      [isVisa.value],
    );

    final scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              hasSectionIndicator: false,
              title: 'Горящие туры',
              subtitle: 'Выберите страну',
              hasSubtitle: true,
              backgroundColor: const Color(0xffdc2323),
              hasBackButton: true,
              hasLoadingIndicator: false,
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
                  itemCount: countries.length,
                  itemBuilder: (_, index) => Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                      left: 54.0,
                      right: 54.0,
                      bottom: index == data.length - 1 ? 20.0 : 0.0,
                    ),
                    child: ListButtonWidget(
                      text: countries[index].name,
                      onTap: () => onSelect(countries[index]),
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
