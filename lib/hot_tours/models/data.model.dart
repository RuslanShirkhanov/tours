import 'package:hot_tours/models/abstract_data.model.dart';

import 'package:hot_tours/models/tour.model.dart';

class DataModel extends AbstractDataModel {
  final TourModel? tour;

  const DataModel({
    required this.tour,
    required String? name,
    required String? number,
  }) : super(name: name, number: number);

  static DataModel empty() => const DataModel(
        tour: null,
        name: null,
        number: null,
      );

  @override
  String toString() => '''
      Горящий тур
      Дата: ${DateTime.now()}
      Откуда: ${tour!.departCityName}
      Куда: ${tour!.targetCountryName}, ${tour!.targetCityName} 
      Отель: ${tour!.hotelName}
      Даты: ${tour!.dateIn} - ${tour!.dateOut}
      Количество ночей: ${tour!.nightsCount}
      Взрослые: ${tour!.adultsCount}
      Дети: ${tour!.childrenCount}
      Имя: $name
      Номер: $number
      Цена: ${tour!.cost} ${tour!.costCurrency}
    '''
      .trim()
      .replaceAll(RegExp(r'[\s]{2,}'), '\n');

  DataModel setTour(TourModel value) => DataModel(
        tour: value,
        name: name,
        number: number,
      );

  @override
  DataModel setName(String value) => DataModel(
        tour: tour,
        name: value,
        number: number,
      );

  @override
  DataModel setNumber(String value) => DataModel(
        tour: tour,
        name: name,
        number: value,
      );
}
