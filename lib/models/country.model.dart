import 'package:equatable/equatable.dart';

import 'unsigned.dart';

class CountryModel extends Equatable {
  final U<int> id;
  final String name;
  final bool isVisa;
  final bool hasTickets;
  final bool hotelIsNotInStop;
  final bool areTicketsIncluded;

  const CountryModel({
    required this.id,
    required this.name,
    required this.isVisa,
    required this.hasTickets,
    required this.hotelIsNotInStop,
    required this.areTicketsIncluded,
  });

  @override
  List<Object> get props => [id];

  static CountryModel serialize(Map<String, dynamic> data) => CountryModel(
        id: U(data['Id'] as int),
        name: (data['Name'] as String).trim(),
        isVisa: data['IsVisa'] as bool,
        hasTickets: data['HasTickets'] as bool,
        hotelIsNotInStop: data['HotelIsNotInStop'] as bool,
        areTicketsIncluded: data['TicketsIncluded'] as bool,
      );

  static Map<String, dynamic> deserialize(CountryModel data) =>
      <String, dynamic>{
        'Id': data.id.value,
        'Name': data.name,
        'IsVisa': data.isVisa,
        'HasTickets': data.hasTickets,
        'HotelIsNotInStop': data.hotelIsNotInStop,
        'TicketsIncluded': data.areTicketsIncluded,
      };
}
