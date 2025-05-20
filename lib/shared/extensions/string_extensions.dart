extension StringCasingExtension on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}