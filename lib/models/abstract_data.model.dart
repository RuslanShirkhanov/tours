abstract class AbstractDataModel {
  final String? name;
  final String? number;

  const AbstractDataModel({
    this.name,
    this.number,
  });

  AbstractDataModel setName(String value);
  AbstractDataModel setNumber(String value);
}
