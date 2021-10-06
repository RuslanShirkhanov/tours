class U<T extends num> {
  final T value;

  const U(this.value) : assert(value >= 0);

  static U<T> of<T extends num>(T value) => U<T>(value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(covariant U<T> that) {
    return value == that.value;
  }

  bool eq(T value) {
    return this.value == value;
  }

  bool operator <(U<T> that) {
    return value < that.value;
  }

  bool lt(T value) {
    return this.value < value;
  }

  bool operator <=(U<T> that) {
    return value <= that.value;
  }

  bool lte(T value) {
    return this.value <= value;
  }

  bool operator >(U<T> that) {
    return value > that.value;
  }

  bool gt(T value) {
    return this.value > value;
  }

  bool operator >=(U<T> that) {
    return value >= that.value;
  }

  bool gte(T value) {
    return this.value >= value;
  }

  U<T> operator +(U<T> that) {
    return U<T>((value + that.value).abs() as T);
  }

  U<T> operator -(U<T> that) {
    return U<T>((value - that.value).abs() as T);
  }

  U<T> operator *(U<T> that) {
    return U<T>((value * that.value).abs() as T);
  }

  U<num> operator /(U<T> that) {
    return U<num>((value / that.value).abs());
  }

  U<num> operator %(U<T> that) {
    return U<num>((value % that.value).abs());
  }

  int toInt() {
    return value.toInt();
  }

  double toDouble() {
    return value.toDouble();
  }

  @override
  String toString() {
    return value.toString();
  }
}
