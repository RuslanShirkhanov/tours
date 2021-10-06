extension Sorted<T> on List<T> {
  List<T> sorted([int Function(T, T)? compare]) {
    final copy = [...this];
    copy.sort(compare);
    return copy;
  }
}
