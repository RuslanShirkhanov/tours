import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';
import 'package:hot_tours/models/hotel.model.dart';
import 'package:hot_tours/models/star.model.dart';

import 'package:hot_tours/search_tours/routes/select_many.route.dart';

void showSelectHotelsRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectHotelsRoute(
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

class SelectHotelsRoute extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectHotelsRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    final hotels = useState(<HotelModel>[]);

    useEffect(() {
      setState<bool>(isLoading)(true);

      Api.getHotels(
        countryId: data.targetCountry!.id,
        towns: data.targetCities!.map((city) => city.id).toList(),
        stars: StarModel.difference(selected: data.hotelStars!)
            .map((star) => star.id)
            .toList(),
      ).then((value) {
        hotels.value = value;

        setState<bool>(isLoading)(false);
      });
    }, []);

    return SelectManyRoute<HotelModel>(
      hasLoadingIndicator: true,
      isLoading: isLoading.value,
      title: 'Поиск туров',
      subtitle: 'Выберите отель',
      primaryData: hotels.value,
      secondaryData: const [],
      isSecondarySingle: true,
      transform: (city) => city.name,
      onContinue: (indices) => onContinue(
        data.setHotels(
          indices.map((index) => hotels.value[index]).toList(),
        ),
      ),
    );
  }
}
