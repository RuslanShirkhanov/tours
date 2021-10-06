import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/models/abstract_data.model.dart';
import 'package:hot_tours/models/depart_city.model.dart';

class DataModel implements AbstractDataModel {
  final U<int> sectionIndex;
  final DepartCityModel? departCity;
  final List<String>? targetCountry;
  final List<String>? what;
  final List<String>? when;
  final List<String>? howLong;
  final String? name;
  final String? number;

  const DataModel({
    required this.sectionIndex,
    required this.departCity,
    required this.targetCountry,
    required this.what,
    required this.when,
    required this.howLong,
    required this.name,
    required this.number,
  });

  factory DataModel.empty() => const DataModel(
        sectionIndex: const U(0),
        departCity: null,
        targetCountry: null,
        what: null,
        when: null,
        howLong: null,
        name: null,
        number: null,
      );

  @override
  String toString() {
    return '''
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
  }

  DataModel setDepartCity(DepartCityModel? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: value,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setTargetCountries(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: departCity,
        targetCountry: value,
        what: what,
        when: when,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setWhat(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: value,
        when: when,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setWhen(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: value,
        howLong: howLong,
        name: name,
        number: number,
      );

  DataModel setHowLong(List<String>? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: value,
        name: name,
        number: number,
      );

  DataModel setName(String? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: howLong,
        name: value,
        number: number,
      );

  DataModel setNumber(String? value) => DataModel(
        sectionIndex: sectionIndex + U(1),
        departCity: departCity,
        targetCountry: targetCountry,
        what: what,
        when: when,
        howLong: howLong,
        name: name,
        number: value,
      );
}
