abstract class AbstractDataModel {
  final String? name;
  final String? number;

  const AbstractDataModel({
    required this.name,
    required this.number,
  });

  AbstractDataModel setName(String value);
  AbstractDataModel setNumber(String value);
}
