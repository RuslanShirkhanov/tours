import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/connection.dart';

import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';

void showSelectDepartCityRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectDepartCityRoute(
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

class SelectDepartCityRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectDepartCityRoute({
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

    final departCities = useState(<DepartCityModel>[]);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (connection.value.isNotNone) {
        Api.getDepartCities(showcase: false).then((value) {
          departCities.value = value.sorted((a, b) => a.name.compareTo(b.name));
          setState<bool>(isLoading)(false);
        });
      }
    }, [connection.value]);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Поиск туров',
              subtitle: 'Выберите город вылета',
              hasSubtitle: true,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: true,
              isLoading: isLoading.value,
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  children: <Widget>[
                    for (int i = 0; i < departCities.value.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 18.0,
                          right: 60.0,
                          bottom: 10.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Opacity(
                              opacity: i == 0 ||
                                      departCities.value[i - 1].name[0] !=
                                          departCities.value[i].name[0]
                                  ? 1.0
                                  : 0.0,
                              child: SizedBox(
                                width: 24.0,
                                child: Center(
                                  child: Text(
                                    departCities.value[i].name[0],
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
                                text: departCities.value[i].name,
                                onTap: () => onContinue(
                                  data.setDepartCity(departCities.value[i]),
                                ),
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
