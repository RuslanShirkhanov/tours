import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/depart_city.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';

void showSelectDepartCityRoute({
  required BuildContext context,
  required List<DepartCityModel> data,
  required void Function(DepartCityModel) onSelect,
}) =>
    showRoute<List<DepartCityModel>>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectDepartCityRoute(
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

class SelectDepartCityRoute extends HookWidget {
  final List<DepartCityModel> data;
  final void Function(DepartCityModel) onSelect;

  const SelectDepartCityRoute({
    Key? key,
    required this.data,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Горящие туры',
              subtitle: 'Выберите город вылета',
              hasSubtitle: true,
              backgroundColor: const Color(0xffdc2323),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: ListView(
                  shrinkWrap: true,
                  controller: scrollController,
                  children: <Widget>[
                    for (int i = 0; i < data.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          left: 18.0,
                          right: 60.0,
                          bottom: i == data.length - 1 ? 20.0 : 0.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Opacity(
                              opacity: i == 0 ||
                                      data[i - 1].name[0] != data[i].name[0]
                                  ? 1.0
                                  : 0.0,
                              child: SizedBox(
                                width: 24.0,
                                child: Center(
                                  child: Text(
                                    data[i].name[0],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 24.0,
                                      color: Color(0xffa0a0a0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18.0),
                            Expanded(
                              child: ListButtonWidget(
                                text: data[i].name,
                                onTap: () => onSelect(data[i]),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
