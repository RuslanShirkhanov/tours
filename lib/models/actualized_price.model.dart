import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/tour.model.dart';

class ActualizedPriceModel {
  final U<int> cost;
  final String costCurrency;

  const ActualizedPriceModel({
    required this.cost,
    required this.costCurrency,
  });

  static ActualizedPriceModel serialize({
    required TourModel tour,
    required List<dynamic> data,
  }) =>
      ActualizedPriceModel(
        cost: U(int.tryParse(data[19] as String) ?? tour.cost.value) *
            tour.adultsCount,
        costCurrency: data[23] as String,
      );
}
