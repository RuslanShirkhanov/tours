extension Singleton on String {
  bool get isSingleton => length == 1;
}

extension Capitalized on String {
  String get capitalized {
    if (isEmpty) {
      return this;
    } else if (isSingleton) {
      return toUpperCase();
    } else {
      return '${this[0].toUpperCase()}${substring(1)}';
    }
  }
}

extension Uncapitalized on String {
  String get uncapitalized {
    if (isEmpty) {
      return this;
    } else if (isSingleton) {
      return toLowerCase();
    } else {
      return '${this[0].toLowerCase()}${substring(1)}';
    }
  }
}
