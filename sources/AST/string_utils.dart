// TODO: replace regexp logic with faster implementation
bool isDigit(String value) {
  return RegExp(r'^\d$').hasMatch(value);
}

bool isWhitespace(String value) {
  return value.trim().isEmpty;
}

bool isLetter(String value) {
  return RegExp(r'^[a-zA-Z]$').hasMatch(value);
}
