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

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/select_stars.widget.dart';
import 'package:hot_tours/hot_tours/widgets/card.widget.dart';

import 'package:hot_tours/hot_tours/routes/select_depart_city.route.dart';
import 'package:hot_tours/hot_tours/routes/select_target_country.route.dart';

String countryCode(String value) =>
    const <String, String>{
      'абхазия': 'ab',
      'австрия': 'at',
      'азербайджан': 'az',
      'албания': 'al',
      'андорра': 'ad',
      'аргентина': 'ar',
      'армения': 'am',
      'багамы': 'bs',
      'бангладеш': 'bd',
      'барбадос': 'bb',
      'бахрейн': 'bh',
      'беларусь': 'by',
      'белиз': 'bz',
      'бельгия': 'be',
      'боливия': 'bo',
      'босния и герцеговина': 'ba',
      'ботсвана': 'bw',
      'бразилия': 'br',
      'венгрия': 'hu',
      'венесуэлла': 've',
      'вьетнам': 'vn',
      'гватемала': 'gt',
      'германия': 'de',
      'греция': 'gr',
      'грузия': 'ge',
      'дания': 'dk',
      'доминикана': 'dm',
      'египет': 'eg',
      'израиль': 'il',
      'индонезия': 'id',
      'иордания': 'jo',
      'исландия': 'is',
      'испания': 'es',
      'италия': 'it',
      'казахстан': 'kz',
      'катар': 'qa',
      'кипр': 'cy',
      'коста-рика': 'cr',
      'куба': 'cu',
      'кыргызстан': 'kg',
      'латвия': 'lv',
      'литва': 'lt',
      'маврикий': 'mu',
      'македония': 'mk',
      'малайзия': 'my',
      'мальдивы': 'mv',
      'мальта': 'mt',
      'марокко': 'ma',
      'молдавия': 'md',
      'намибия': 'na',
      'нидерланды': 'nl',
      'норвегия': 'no',
      'оаэ': 'ae',
      'оман': 'om',
      'панама': 'pa',
      'парагвай': 'py',
      'перу': 'pe',
      'польша': 'pl',
      'португалия': 'pt',
      'россия': 'ru',
      'сейшелы': 'sc',
      'сербия': 'rs',
      'словакия': 'sk',
      'словения': 'sl',
      'таджикистан': 'tj',
      'таиланд': 'th',
      'тайвань': 'tw',
      'теркс и кайкой': 'tc',
      'тунис': 'tn',
      'турция': 'tr',
      'уганда': 'ug',
      'узбекистан': 'uz',
      'украина': 'ua',
      'фиджи': 'fj',
      'флиппины': 'ph',
      'финляндия': 'fi',
      'франция': 'fr',
      'черногория': 'me',
      'чехия': 'cz',
      'чили': 'cl',
      'швейцария': 'ch',
      'швеция': 'se',
      'шри-ланка': 'lk',
      'эквадор': 'ec',
      'эстония': 'ee',
      'эфиопия': 'et',
      'юар': 'za',
      'южная корея': 'kr',
      'ямайка': 'jm',
    }[value.toLowerCase()] ??
    '';

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

      if (connection.value.isNotNone) {
        Api.getDepartCities().then((value) {
          departCities.value = value.sorted((a, b) => a.name.compareTo(b.name));
          setState<DepartCityModel?>(selectedCity)(value[0]);
        });
      }
    }, [connection.value]);

    final targetCountries = useState(const <CountryModel>[]);
    final selectedCountry = useState<CountryModel?>(null);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (selectedCity.value != null) {
        Api.getCountries(townFromId: selectedCity.value!.id).then((value) {
          targetCountries.value =
              value.sorted((a, b) => a.name.compareTo(b.name));
          if (!targetCountries.value.contains(selectedCountry.value)) {
            setState<CountryModel?>(selectedCountry)(value[0]);
          }
        });
      }
    }, [selectedCity.value]);

    final selectedStars = useState(StarModel.getStars.take(3).toList());

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
            NavBarWidget(
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
                isFlag: true,
                path:
                    'icons/flags/png/${countryCode(selectedCountry.value?.name ?? '')}.png',
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
                  stars: selectedStars.value,
                  onSelect: setState<List<StarModel>>(selectedStars),
                ),
              ],
            ),
            if (!isLoading.value && tours.value.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Center(
                  child: Text(
                    'Туры не найдены :(',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                      color: Color(0xff4d4948),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: isLoading.value ? 0.0 : 1.0,
                child: Scrollbar(
                  controller: scrollController,
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
            ),
          ],
        ),
      ),
    );
  }
}
