extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.capitalize())
        .join(' ');
  }

  String truncate(int length, {String suffix = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$suffix';
  }

  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  bool get isPhoneNumber {
    return RegExp(r'^\d{10}$').hasMatch(this);
  }

  String removeSpecialCharacters() {
    return replaceAll(RegExp(r'[^\w\s]'), '');
  }

  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  String? get nullIfEmpty => isEmpty ? null : this;

  String formatAsInitials({int maxLength = 2}) {
    final words = trim().split(RegExp(r'\s+'));
    final initials = words
        .take(maxLength)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
    return initials;
  }
}

extension StringNullExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  
  String get orEmpty => this ?? '';
  
  String ifEmpty(String defaultValue) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}
