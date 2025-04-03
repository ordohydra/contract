import 'package:test/test.dart';
import '../../Sources/AST/string_utils.dart';

void main() {
  test('isWhitespace', () {
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
}
