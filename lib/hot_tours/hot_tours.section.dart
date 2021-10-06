import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/connection.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/hot_tours/models/data.model.dart';
import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/models/star.model.dart';
import 'package:hot_tours/models/tour.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/select_stars.widget.dart';
import 'package:hot_tours/hot_tours/widgets/card.widget.dart';

import 'package:hot_tours/hot_tours/routes/select_depart_city.route.dart';
import 'package:hot_tours/hot_tours/routes/select_target_country.route.dart';

void showHotToursSection({
  required BuildContext context,
}) =>
    showRoute<DataModel>(
      context: context,
      model: DataModel.empty(),
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => HotToursSection(data: data!),
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

class HotToursSection extends HookWidget {
  final DataModel data;

  const HotToursSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final connection = ConnectionUtil.useConnection();

    final scrollController = useScrollController();

    final isLoading = useState(false);

    final departCities = useState(const <DepartCityModel>[]);
    final selectedCity = useState<DepartCityModel?>(null);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (connection.value.isNotNone)
        Api.getDepartCities().then((value) {
          departCities.value = value.sorted((a, b) => a.name.compareTo(b.name));
          setState<DepartCityModel?>(selectedCity)(value[0]);
        });
    }, [connection.value]);

    final targetCountries = useState(const <CountryModel>[]);
    final selectedCountry = useState<CountryModel?>(null);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (selectedCity.value != null)
        Api.getCountries(townFromId: selectedCity.value!.id).then((value) {
          targetCountries.value =
              value.sorted((a, b) => a.name.compareTo(b.name));
          if (!targetCountries.value.contains(selectedCountry))
            setState<CountryModel?>(selectedCountry)(value[0]);
        });
    }, [selectedCity.value]);

    final selectedStars = useState(StarModel.getStars());

    final tours = useState(<TourModel>[]);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (selectedCity.value != null && selectedCountry.value != null) {
        Api.getHotTours(
          cityFromId: selectedCity.value!.id,
          countryId: selectedCountry.value!.id,
          stars: StarModel.difference(selected: selectedStars.value)
              .map((star) => star.id)
              .toList(),
        ).then((value) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 350), curve: Curves.ease);
          tours.value = value.sorted(
              (a, b) => a.hotelStar.id.value.compareTo(b.hotelStar.id.value));

          setState<bool>(isLoading)(false);
        });
      }
    }, [selectedCountry.value, selectedStars.value]);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              hasSectionIndicator: false,
              title: 'Горящие туры',
              hasSubtitle: false,
              backgroundColor: const Color(0xffdc2323),
              hasBackButton: true,
              isLoading: isLoading.value,
              hasLoadingIndicator: true,
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ListButtonWidget(
                text: selectedCity.value?.name ?? '',
                onTap: () => showSelectDepartCityRoute(
                  context: context,
                  data: departCities.value,
                  onSelect: setState<DepartCityModel?>(selectedCity),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ListButtonWidget(
                text: selectedCountry.value?.name ?? '',
                onTap: () => showSelectTargetCountryRoute(
                  context: context,
                  data: targetCountries.value,
                  onSelect: setState<CountryModel?>(selectedCountry),
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Отель от',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                    color: const Color(0xff7d7d7d),
                  ),
                ),
                const SizedBox(width: 6.0),
                SelectStarsWidget(
                  stars: selectedStars.value,
                  onSelect: setState<List<StarModel>>(selectedStars),
                ),
              ],
            ),
            if (!isLoading.value && tours.value.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: const Center(
                  child: const Text(
                    'Туры не найдены :(',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                      color: const Color(0xff4d4948),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: isLoading.value ? 0.0 : 1.0,
                child: ListView(
                  controller: scrollController,
                  children: tours.value
                      .map((tour) => Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CardWidget(data: data.setTour(tour)),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
