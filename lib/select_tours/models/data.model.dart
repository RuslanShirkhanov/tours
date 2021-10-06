import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/models/abstract_data.model.dart';
import 'package:hot_tours/models/depart_city.model.dart';

class DataModel extends AbstractDataModel {
  final U<int> sectionIndex;
  final DepartCityModel? departCity;
  final List<String>? targetCountry;
  final List<String>? what;
  final List<String>? when;
  final List<String>? howLong;

  const DataModel({
    required this.sectionIndex,
    required this.departCity,
    required this.targetCountry,
    required this.what,
    required this.when,
    required this.howLong,
    required String? name,
    required String? number,
  }) : super(name: name, number: number);

  factory DataModel.empty() => const DataModel(
        sectionIndex: U(0),
        departCity: null,
        targetCountry: null,
        what: null,
        when: null,
        howLong: null,
        name: null,
        number: null,
      );

  @override
  String toString() => '''
      Подбор тура
      Дата: ${DateTime.now()}
      Откуда: ${departCity!.name}
      Куда: ${targetCountry!.join(', ')}
      Вид отдыха: ${what!.map((x) => x.toLowerCase()).join(', ')}
      Время вылета: ${when!.map((x) => x.toLowerCase()).join(', ')}
      Протяжённость отдыха: ${howLong!.map((x) => x.toLowerCase()).join(', ')}
      Имя: ${name!}
      Номер: ${number!}
    '''
      .trim()
      .replaceAll(RegExp(r'[\s]{2,}'), '\n');

  DataModel setDepartCity(DepartCityModel? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: value,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setTargetCountries(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: departCity,
        targetCountry: value,
        what: what,
        when: when,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setWhat(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: value,
        when: when,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setWhen(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: value,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setHowLong(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: value,
        name: name,
        number: number,
      );

  @override
  DataModel setName(String? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: howLong,
        name: value,
        number: number,
      );

  @override
  DataModel setNumber(String? value) => DataModel(
        sectionIndex: sectionIndex + const U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: howLong,
        name: name,
        number: value,
      );
}
