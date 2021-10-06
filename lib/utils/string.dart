extension Singleton on String {
  bool get isSingleton => length == 1;
}

extension Capitalized on String {
  String get capitalized {
    if (this.isEmpty) {
      return this;
    } else if (this.isSingleton) {
      return this.toUpperCase();
    } else {
      return '${this[0].toUpperCase()}${this.substring(1)}';
    }
  }
}

extension Uncapitalized on String {
  String get uncapitalized {
    if (this.isEmpty) {
      return this;
    } else if (this.isSingleton) {
      return this.toLowerCase();
    } else {
      return '${this[0].toLowerCase()}${this.substring(1)}';
    }
  }
}
