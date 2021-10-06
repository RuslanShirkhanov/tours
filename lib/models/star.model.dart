import 'unsigned.dart';

class StarModel {
  final U<int> id;
  final String name;

  const StarModel({
    required this.id,
    required this.name,
  });

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(covariant StarModel that) => name == that.name;

  static StarModel serialize(Map<String, dynamic> data) =>
      StarModel(id: U<int>(data['id'] as int), name: data['name']);

  static Map<String, dynamic> deserialize(StarModel data) =>
      <String, dynamic>{'id': data.id.value, 'name': data.name};

  static List<StarModel> getStars() => const [
        StarModel(id: U<int>(400), name: '1*'),
        StarModel(id: U<int>(401), name: '2*'),
        StarModel(id: U<int>(402), name: '3*'),
        StarModel(id: U<int>(403), name: '4*'),
        StarModel(id: U<int>(404), name: '5*'),
      ];

  static List<StarModel> getAllStars() => [
        ...StarModel.getStars(),
        StarModel(id: U<int>(405), name: 'Apts'),
      ];

  static String idToName(U<int> id) {
    final stars = StarModel.getAllStars();
    assert(stars.map((star) => star.id).contains(id));
    if (id == U<int>(405)) return '5*';
    return stars.firstWhere((star) => star.id == id).name;
  }

  static U<int> nameToId(String name) {
    final stars = StarModel.getAllStars();
    assert(stars.map((star) => star.name).contains(name));
    if (name == 'Apts') return U<int>(404);
    return stars.firstWhere((star) => star.name == name).id;
  }

  static List<StarModel> difference({
    List<StarModel>? all,
    required List<StarModel> selected,
  }) {
    final allStars = (all ?? StarModel.getStars()).toSet();
    final selectedStars = selected.toSet();
    final difference = allStars.difference(selectedStars);
    final result = [selected.last, ...difference];
    return result;
  }
}
