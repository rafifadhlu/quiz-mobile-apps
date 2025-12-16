extension StringCasingExtension on String {
  // Capitalizes the first letter of a single word/sentence
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  
  // Capitalizes the first letter of every word (Title Case)
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}