// TODO: replace regexp logic with faster implementation
bool isDigit(String value) {
  return RegExp(r'^\d$').hasMatch(value);
}

bool isWhitespace(String value) {
  return value == ' ' || value == '\r' || value == '\f' || value == '\v';
}

bool isLetter(String value) {
  return RegExp(r'^[a-zA-Z]$').hasMatch(value);
}

bool isAlphanumeric(String value) {
  return RegExp(r'^[a-zA-Z0-9]$').hasMatch(value);
}
