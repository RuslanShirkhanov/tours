import 'package:equatable/equatable.dart';

import 'unsigned.dart';

class StarModel extends Equatable {
  final U<int> id;
  final String name;

  const StarModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [name];

  static StarModel serialize(Map<String, dynamic> data) => StarModel(
        id: U<int>(data['id'] as int),
        name: (data['name'] as String).trim(),
      );

  static Map<String, dynamic> deserialize(StarModel data) => <String, dynamic>{
        'id': data.id.value,
        'name': data.name,
      };

  static const getStars = [
    StarModel(id: U<int>(400), name: '1*'),
    StarModel(id: U<int>(401), name: '2*'),
    StarModel(id: U<int>(402), name: '3*'),
    StarModel(id: U<int>(403), name: '4*'),
    StarModel(id: U<int>(404), name: '5*'),
  ];

  static final getAllStars = [
    ...StarModel.getStars,
    const StarModel(id: U<int>(405), name: 'Apts'),
    const StarModel(id: U<int>(405), name: 'Villas'),
  ];

  static String idToName(U<int> id) {
    final stars = StarModel.getAllStars;
    assert(stars.map((star) => star.id).contains(id));
    if (id == const U<int>(405)) {
      return '5*';
    }
    return stars.firstWhere((star) => star.id == id).name;
  }

  static U<int> nameToId(String name) {
    final stars = StarModel.getAllStars;
    assert(stars.map((star) => star.name).contains(name));
    if (name == 'Apts' || name == 'Villas') {
      return const U<int>(404);
    }
    return stars.firstWhere((star) => star.name == name).id;
  }

  static List<StarModel> difference({
    List<StarModel>? all,
    required List<StarModel> selected,
  }) {
    final allStars = (all ?? StarModel.getStars).toSet();
    final selectedStars = selected.toSet();
    final difference = allStars.difference(selectedStars);
    final result = [selected.last, ...difference];
    return result;
  }
}
