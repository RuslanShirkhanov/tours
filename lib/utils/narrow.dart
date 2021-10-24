extension Narrow<T> on List<T> {
  List<List<T>> narrow(bool Function(T, T) p) {
    if (isEmpty) {
      return <List<T>>[];
    }

    final result = <List<T>>[];
    var unit = <T>[first];

    for (int i = 1; i < length; i++) {
      if (p(elementAt(i), unit.first)) {
        unit.add(elementAt(i));
      } else {
        result.add(unit);
        unit = [elementAt(i)];
      }
    }
    result.add(unit);

    return result;
  }
}
