extension StringCasingExtension on String {
  String toCapitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  // String yourStringModifyingMethod() => write your logic here to modify the string as per your need;
}