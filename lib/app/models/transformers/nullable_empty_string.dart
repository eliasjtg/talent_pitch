String? nullableEmptyString(dynamic value) {
  return value is String && value.trim().isNotEmpty ? value : null;
}
