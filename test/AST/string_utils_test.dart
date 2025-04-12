import 'package:test/test.dart';
import '../../Sources/AST/string_utils.dart';

void main() {
  test('Test isWhitespace', () {
    expect(isWhitespace(' '), isTrue);
    expect(isWhitespace('\t'), isTrue);
    expect(isWhitespace('\n'), isTrue);
    expect(isWhitespace('a'), isFalse);
    expect(isWhitespace('1'), isFalse);
    expect(isWhitespace('a b'), isFalse);
    expect(isWhitespace('1 2'), isFalse);
    expect(isWhitespace('a1'), isFalse);
    expect(isWhitespace('1a'), isFalse);
    expect(isWhitespace('a\nb'), isFalse);
    expect(isWhitespace('a\tb'), isFalse);
    expect(isWhitespace('a b\nc'), isFalse);
  });

  test('Test isDigit', () {
    expect(isDigit('0'), isTrue);
    expect(isDigit('1'), isTrue);
    expect(isDigit('2'), isTrue);
    expect(isDigit('3'), isTrue);
    expect(isDigit('4'), isTrue);
    expect(isDigit('5'), isTrue);
    expect(isDigit('6'), isTrue);
    expect(isDigit('7'), isTrue);
    expect(isDigit('8'), isTrue);
    expect(isDigit('9'), isTrue);
    expect(isDigit('a'), isFalse);
    expect(isDigit('A'), isFalse);
    expect(isDigit(' '), isFalse);
  });

  test('Test isLetter', () {
    expect(isLetter('a'), isTrue);
    expect(isLetter('b'), isTrue);
    expect(isLetter('c'), isTrue);
    expect(isLetter('A'), isTrue);
    expect(isLetter('B'), isTrue);
    expect(isLetter('C'), isTrue);
    expect(isLetter('1'), isFalse);
    expect(isLetter(' '), isFalse);
  });

  test('Test isAlphanumeric', () {
    expect(isAlphanumeric('a'), isTrue);
    expect(isAlphanumeric('b'), isTrue);
    expect(isAlphanumeric('c'), isTrue);
    expect(isAlphanumeric('A'), isTrue);
    expect(isAlphanumeric('B'), isTrue);
    expect(isAlphanumeric('C'), isTrue);
    expect(isAlphanumeric('1'), isTrue);
    expect(isAlphanumeric(' '), isFalse);
  });
}
