extension MapToList<A> on List<A> {
  List<B> mapToList<B>(B Function(A, int) f) {
    final result = <B>[];
    if (isEmpty) {
      return result;
    }
    for (int i = 0; i < length; i++) {
      result.add(f(this[i], i));
    }
    return result;
  }
}
