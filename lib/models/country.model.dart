import 'unsigned.dart';

class CountryModel {
  final U<int> id;
  final U<int> rank;
  final String name;
  final String alias;
  final U<int> flag;
  final bool isVisa;
  final bool hasTickets;
  final bool areTicketsIncluded;
  final bool isHotelNotInStop;

  const CountryModel({
    required this.id,
    required this.rank,
    required this.name,
    required this.alias,
    required this.flag,
    required this.isVisa,
    required this.hasTickets,
    required this.areTicketsIncluded,
    required this.isHotelNotInStop,
  });

  factory CountryModel.empty() {
    return CountryModel(
      id: U<int>(0),
      rank: U<int>(0),
      name: '',
      alias: '',
      flag: U<int>(0),
      isVisa: false,
      hasTickets: false,
      areTicketsIncluded: false,
      isHotelNotInStop: false,
    );
  }

  static CountryModel serialize(Map<String, dynamic> data) => CountryModel(
        id: U<int>(data['Id'] as int),
        rank: U<int>(data['Rank'] as int),
        name: data['Name'] as String,
        alias: data['Alias'] as String,
        flag: U<int>(data['Flags'] as int),
        isVisa: data['IsVisa'] as bool,
        hasTickets: data['HasTickets'] as bool,
        areTicketsIncluded: data['TicketsIncluded'] as bool,
        isHotelNotInStop: data['HotelIsNotInStop'] as bool,
      );

  static Map<String, dynamic> deserialize(CountryModel data) => {
        'Id': data.id.value,
        'Rank': data.rank.value,
        'Name': data.name,
        'Alias': data.alias,
        'Flags': data.flag.value,
        'IsVisa': data.isVisa,
        'HasTickets': data.hasTickets,
        'TicketsIncluded': data.areTicketsIncluded,
        'HotelIsNotInStop': data.isHotelNotInStop,
      };
}
