import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';
import 'package:hot_tours/search_tours/models/storage.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/select_tours/widgets/button.widget.dart';

import 'package:hot_tours/search_tours/routes/other_params.route.dart';
import 'package:hot_tours/search_tours/routes/select_nights_count.route.dart';
import 'package:hot_tours/search_tours/routes/select_people_count.route.dart';
import 'package:hot_tours/search_tours/routes/select_target_country.route.dart';
import 'package:hot_tours/search_tours/routes/select_depart_city.route.dart';
import 'package:hot_tours/search_tours/routes/select_tour_dates.route.dart';
import 'package:hot_tours/search_tours/routes/loading.route.dart';

void showSearchToursSection({
  required BuildContext context,
  DataModel? data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data ?? DataModel.empty(),
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SearchToursSection(
          data: currentData!,
          onContinue: (newData) => showLoadingRoute(
            context: context,
            data: newData,
          ),
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

class SearchToursSection extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SearchToursSection({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    final currentData = useState(data);

    useEffect(() {
      setState<bool>(isLoading)(true);

      StorageController.read().then((storage) {
        currentData.value = storage.data;

        setState<bool>(isLoading)(false);
      });
    }, []);

    void setCurrentData(DataModel value) => currentData.value = value;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
                hasSectionIndicator: false,
                title: 'Поиск туров',
                hasSubtitle: false,
                backgroundColor: const Color(0xff2eaeee),
                hasBackButton: true,
                isLoading: isLoading.value,
                hasLoadingIndicator: true,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 70.0,
                    left: 50.0,
                    right: 50.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      ListButtonWidget(
                        text: currentData.value.departCity?.name ??
                            'Город отправления',
                        onTap: () => showSelectDepartCityRoute(
                          context: context,
                          data: currentData.value,
                          onContinue: setCurrentData,
                        ),
                      ),
                      const SizedBox(height: 26.0),
                      ListButtonWidget(
                        isActive: currentData.value.departCity != null,
                        text: currentData.value.targetCountry?.name ??
                            'Страна направления',
                        onTap: () => showSelectTargetCountryRoute(
                          context: context,
                          data: currentData.value,
                          onContinue: setCurrentData,
                        ),
                      ),
                      const SizedBox(height: 26.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: ListButtonWidget(
                              isActive: currentData.value.targetCountry != null,
                              text: 'Даты вылета',
                              onTap: () => showSelectDatesRoute(
                                context: context,
                                data: currentData.value,
                                onContinue: setCurrentData,
                              ),
                            ),
                          ),
                          const SizedBox(width: 22.0),
                          Flexible(
                            child: ListButtonWidget(
                              isActive: currentData.value.tourDates != null,
                              text: currentData.value.nightsCount != null
                                  ? '${currentData.value.nightsCount!.fst} - ${currentData.value.nightsCount!.snd} ночей'
                                  : 'Количество ночей',
                              onTap: () => showSelectNightsCountRoute(
                                context: context,
                                data: currentData.value,
                                onContinue: setCurrentData,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: ListButtonWidget(
                              isActive: currentData.value.tourDates != null &&
                                  currentData.value.nightsCount != null,
                              text: currentData.value.peopleCount != null
                                  ? currentData.value.peopleCount!.snd ==
                                          const U<int>(0)
                                      ? '${currentData.value.peopleCount!.fst} взр'
                                      : '${currentData.value.peopleCount!.fst} взр - ${currentData.value.peopleCount!.snd} реб'
                                  : 'Количество людей',
                              onTap: () => showSelectPeopleCountRoute(
                                context: context,
                                data: currentData.value,
                                onContinue: setCurrentData,
                              ),
                            ),
                          ),
                          const SizedBox(width: 22.0),
                          Flexible(
                            child: ListButtonWidget(
                              isActive: currentData.value.tourDates != null &&
                                  currentData.value.peopleCount != null,
                              path: 'assets/select.svg',
                              onTap: () => showOtherParamsRoute(
                                context: context,
                                data: currentData.value,
                                onContinue: setCurrentData,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonWidget(
                            width: 185.0,
                            height: 45.0,
                            text: 'найти туры',
                            isActive: currentData.value.isValid,
                            onTap: () => onContinue(currentData.value),
                          ),
                        ],
                      ),
                    ],
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
