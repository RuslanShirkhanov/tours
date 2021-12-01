import 'package:hot_tours/models/abstract_data.model.dart';
import 'package:hot_tours/models/actualized_price.model.dart';
import 'package:hot_tours/models/tour.model.dart';

class DataModel extends AbstractDataModel {
  final TourModel? tour;
  final ActualizedPriceModel? actualizedPrice;

  const DataModel({
    required this.tour,
    required this.actualizedPrice,
    required String? name,
    required String? number,
  }) : super(name: name, number: number);

  static DataModel empty() => const DataModel(
        tour: null,
        actualizedPrice: null,
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
      Цена: ${actualizedPrice!.cost} ${actualizedPrice!.costCurrency}
    '''
      .trim()
      .replaceAll(RegExp(r'[\s]{2,}'), '\n');

  DataModel setTour(TourModel value) => DataModel(
        tour: value,
        actualizedPrice: null,
        name: name,
        number: number,
      );

  DataModel setActualizedPrice(ActualizedPriceModel actualizedPrice) =>
      DataModel(
        tour: tour,
        actualizedPrice: actualizedPrice,
        name: name,
        number: number,
      );

  @override
  DataModel setName(String value) => DataModel(
        tour: tour,
        actualizedPrice: actualizedPrice,
        name: value,
        number: number,
      );

  @override
  DataModel setNumber(String value) => DataModel(
        tour: tour,
        actualizedPrice: actualizedPrice,
        name: name,
        number: value,
      );
}
