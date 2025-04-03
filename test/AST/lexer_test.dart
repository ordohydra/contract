import '../../sources/AST/lexer.dart';
import '../../sources/AST/token.dart';
import 'package:test/test.dart';

void main() {
  group('Lexer Tests', () {
    test('Lexer should tokenize a simple string', () {
      final String input = 'hello world';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'hello');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'world');
    });

    test('Lexer should handle whitespace correctly', () {
      final String input = 'hello   world';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'hello');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'world');
    });
  });
}
