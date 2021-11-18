import 'package:hot_tours/utils/pair.dart';

import 'package:hot_tours/models/abstract_data.model.dart';
import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/models/country.model.dart';
import 'package:hot_tours/models/city.model.dart';
import 'package:hot_tours/models/star.model.dart';
import 'package:hot_tours/models/hotel.model.dart';
import 'package:hot_tours/models/meal.model.dart';
import 'package:hot_tours/models/tour.model.dart';

class DataModel extends AbstractDataModel {
  final DepartCityModel? departCity;
  final CountryModel? targetCountry;
  final Pair<DateTime?, DateTime?> tourDates;
  final Pair<U<int>?, U<int>?> nightsCount;
  final Pair<U<int>?, U<int>?> peopleCount;
  final List<U<int>> childrenAges;
  final List<CityModel> targetCities;
  final List<StarModel> hotelStars;
  final List<HotelModel> hotels;
  final List<MealModel> meals;
  final U<double>? rate;
  final TourModel? tour;

  const DataModel({
    required this.departCity,
    required this.targetCountry,
    required this.tourDates,
    required this.nightsCount,
    required this.peopleCount,
    required this.childrenAges,
    required this.targetCities,
    required this.hotelStars,
    required this.hotels,
    required this.meals,
    required this.rate,
    required this.tour,
    required String? name,
    required String? number,
  }) : super(name: name, number: number);

  factory DataModel.empty() => const DataModel(
        departCity: null,
        targetCountry: null,
        tourDates: Pair(null, null),
        nightsCount: Pair(null, null),
        peopleCount: Pair(null, null),
        childrenAges: [],
        targetCities: [],
        hotelStars: [],
        hotels: [],
        meals: [],
        rate: null,
        tour: null,
        name: null,
        number: null,
      );

  @override
  String toString() => '''
      Сезонный тур
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

  bool get isValid => [
        departCity,
        targetCountry,
        tourDates,
        nightsCount,
        peopleCount,
      ]
          .map((x) => x is Pair ? x.isNotEmpty : x != null)
          .reduce((x, y) => x && y);

  DataModel setDepartCity(DepartCityModel value) => DataModel(
        departCity: value,
        targetCountry: null,
        tourDates: const Pair(null, null),
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: [],
        hotelStars: hotelStars,
        hotels: [],
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setTargetCountry(CountryModel value) => DataModel(
        departCity: departCity,
        targetCountry: value,
        tourDates: const Pair(null, null),
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: [],
        hotelStars: hotelStars,
        hotels: [],
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setTourDates(Pair<DateTime, DateTime> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: value,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setNightsCount(Pair<U<int>, U<int>> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: value,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setPeopleCount(Pair<U<int>, U<int>> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: value,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setChildrenAges(List<U<int>> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: value,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setTargetCities(List<CityModel> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: value,
        hotelStars: hotelStars,
        hotels: [],
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setHotelStars(List<StarModel> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: value,
        hotels: [],
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setHotels(List<HotelModel> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: value,
        meals: meals,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setMeals(List<MealModel> value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: value,
        rate: rate,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setRate(U<double>? value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: value,
        tour: null,
        name: name,
        number: number,
      );

  DataModel setTour(TourModel value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: value,
        name: name,
        number: number,
      );

  @override
  DataModel setName(String value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: tour,
        name: value,
        number: number,
      );

  @override
  DataModel setNumber(String value) => DataModel(
        departCity: departCity,
        targetCountry: targetCountry,
        tourDates: tourDates,
        nightsCount: nightsCount,
        peopleCount: peopleCount,
        childrenAges: childrenAges,
        targetCities: targetCities,
        hotelStars: hotelStars,
        hotels: hotels,
        meals: meals,
        rate: rate,
        tour: tour,
        name: name,
        number: value,
      );
}
