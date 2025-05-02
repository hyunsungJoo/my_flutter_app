extension CaseInsensitiveContains on String {
  bool containsIgnoreCase(String other) {
    return this.toLowerCase().contains(other.toLowerCase());
  }
}