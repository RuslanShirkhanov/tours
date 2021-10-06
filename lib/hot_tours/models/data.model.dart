import 'package:hot_tours/models/abstract_data.model.dart';

import 'package:hot_tours/models/tour.model.dart';

class DataModel extends AbstractDataModel {
  final TourModel? tour;
  final String? name;
  final String? number;

  const DataModel({
    required this.tour,
    required this.name,
    required this.number,
  });

  static DataModel empty() => DataModel(
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

  DataModel setName(String value) => DataModel(
        tour: tour,
        name: value,
        number: number,
      );

  DataModel setNumber(String value) => DataModel(
        tour: tour,
        name: name,
        number: value,
      );
}
