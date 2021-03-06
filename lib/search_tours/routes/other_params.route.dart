import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/search_tours/models/storage.model.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';
import 'package:hot_tours/models/city.model.dart';
import 'package:hot_tours/models/hotel.model.dart';
import 'package:hot_tours/models/meal.model.dart';
import 'package:hot_tours/models/star.model.dart';
import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/select_stars.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/checkbox.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

import 'package:hot_tours/search_tours/routes/select_meals.route.dart';
import 'package:hot_tours/search_tours/routes/select_rate.route.dart';
import 'package:hot_tours/search_tours/routes/select_hotels.route.dart';
import 'package:hot_tours/search_tours/routes/select_target_cities.route.dart';

void showOtherParamsRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => OtherParamsRoute(
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

class OtherParamsRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const OtherParamsRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final currentData = useState(
      data.hotelStars.isEmpty
          ? data.setHotelStars(StarModel.getStars.take(3).toList())
          : data,
    );
    final rememberStatus = useState(true);

    void reset() {
      currentData.value = currentData.value.setHotelStars([]).setTargetCities(
          []).setHotels([]).setMeals([]).setRate(null);
    }

    // ignore: avoid_positional_boolean_parameters
    void setRememberStatus(bool value) => rememberStatus.value = value;

    void setCurrentData(DataModel value) => currentData.value = value;

    void setHotelStars(List<StarModel> value) =>
        setCurrentData(currentData.value.setHotelStars(value));

    void setTargetCities(List<CityModel> value) =>
        setCurrentData(currentData.value.setTargetCities(value));

    void setHotels(List<HotelModel> value) =>
        setCurrentData(currentData.value.setHotels(value));

    void setMeals(List<MealModel> value) =>
        setCurrentData(currentData.value.setMeals(value));

    void setRate(U<double> value) =>
        setCurrentData(currentData.value.setRate(value));

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: NavBarWidget(
                  hasSectionIndicator: false,
                  title: '?????????? ??????????',
                  subtitle: '???????????? ??????????????????',
                  hasSubtitle: true,
                  backgroundColor: const Color(0xff2eaeee),
                  hasBackButton: true,
                  hasLoadingIndicator: false,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 78.0, bottom: 70.0),
                  child: Scrollbar(
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        left: 50.0,
                        right: 50.0,
                        bottom: 20.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                '?????????? ????',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                  color: Color(0xff7d7d7d),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              SelectStarsWidget(
                                stars: currentData.value.hotelStars,
                                onSelect: setHotelStars,
                              ),
                            ],
                          ),
                          const SizedBox(height: 35.0),
                          ListButtonWidget(
                            text: currentData.value.targetCities.isEmpty
                                ? '????????????'
                                : currentData.value.targetCities.length == 1
                                    ? '????????????: ${currentData.value.targetCities[0].name}'
                                    : '????????????: ?????????????? (${currentData.value.targetCities.length})',
                            onTap: () => showSelectTargetCitiesRoute(
                              context: context,
                              data: currentData.value,
                              onContinue: (newData) =>
                                  setTargetCities(newData.targetCities),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ListButtonWidget(
                            text: currentData.value.hotels.isEmpty
                                ? '??????????'
                                : currentData.value.hotels.length == 1
                                    ? '??????????: ${currentData.value.hotels[0].name}'
                                    : '??????????: ?????????????? (${currentData.value.hotels.length})',
                            onTap: () => showSelectHotelsRoute(
                              context: context,
                              data: currentData.value,
                              onContinue: (newData) =>
                                  setHotels(newData.hotels),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ListButtonWidget(
                            text: currentData.value.meals.isEmpty
                                ? '??????????????'
                                : currentData.value.meals.length == 1
                                    ? '??????????????: ${mealToString(currentData.value.meals[0])}'
                                    : '??????????????: ?????????????? (${currentData.value.meals.length})',
                            onTap: () => showSelectMealsRoute(
                              context: context,
                              data: currentData.value,
                              onContinue: (newData) => setMeals(newData.meals),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ListButtonWidget(
                            text: currentData.value.rate == null
                                ? '??????????????'
                                : '??????????????: ${rateToString(currentData.value.rate!)}',
                            onTap: () => showSelectRateRoute(
                              context: context,
                              data: currentData.value,
                              onContinue: (newData) => setRate(newData.rate!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100.0,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Center(
                    child: CheckboxWidget(
                      isActive: rememberStatus.value,
                      text: '?????????????????? ??????????',
                      onToggle: setRememberStatus,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FooterWidget(
                  ok: FooterButtonModel(
                    kind: FooterButtonKind.ok,
                    isActive: currentData.value.isValid,
                    onTap: () {
                      if (rememberStatus.value) {
                        StorageController.write(
                          StorageModel.fromData(currentData.value),
                        );
                      }
                      onContinue(currentData.value);
                    },
                  ),
                  cancel: FooterButtonModel(
                    kind: FooterButtonKind.cancel,
                    isActive: true,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  reset: FooterButtonModel(
                    kind: FooterButtonKind.reset,
                    isActive: currentData.value.targetCities.isNotEmpty ||
                        currentData.value.hotels.isNotEmpty ||
                        currentData.value.meals.isNotEmpty ||
                        currentData.value.rate != null,
                    onTap: reset,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
