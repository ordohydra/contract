import 'dart:math';

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

    test('Lexer should handle comments correctly', () {
      final String input = 'hello # this is a comment\nworld';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'hello');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'world');
    });
    test('Lexer should handle numbers correctly', () {
      final String input = '123 456.789';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 2);
      expect(tokens[0].type, TokenType.number);
      expect(tokens[0].value, 123);
      expect(tokens[1].type, TokenType.number);
      expect(tokens[1].value, 456.789);
    });
    test('Lexer should handle parentheses correctly', () {
      final String input = '(hello world)';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 4);
      expect(tokens[0].type, TokenType.lparen);
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'hello');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].value, 'world');
      expect(tokens[3].type, TokenType.rparen);
    });
    test('Lexer should handle operators correctly', () {
      final String input = 'a + b - c * d / e';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 9);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'a');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].value, '+');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].value, 'b');
      expect(tokens[3].type, TokenType.operator);
      expect(tokens[3].value, '-');
      expect(tokens[4].type, TokenType.identifier);
      expect(tokens[4].value, 'c');
      expect(tokens[5].type, TokenType.operator);
      expect(tokens[5].value, '*');
      expect(tokens[6].type, TokenType.identifier);
      expect(tokens[6].value, 'd');
      expect(tokens[7].type, TokenType.operator);
      expect(tokens[7].value, '/');
      expect(tokens[8].type, TokenType.identifier);
      expect(tokens[8].value, 'e');
    });
    test('Lexer should handle invalid characters correctly', () {
      final String input = 'hello @ world';
      final Lexer lexer = Lexer(input);

      expect(() => lexer.tokenize(), throwsA(isA<Exception>()));
    });
    test('Lexer should handle empty input correctly', () {
      final String input = '';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 0);
    });
    test('Lexer should handle complex expressions correctly', () {
      final String input = 'a + b * (c - d) / e';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 11);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'a');
      expect(tokens[1].type, TokenType.operator);
      expect(tokens[1].value, '+');
      expect(tokens[2].type, TokenType.identifier);
      expect(tokens[2].value, 'b');
      expect(tokens[3].type, TokenType.operator);
      expect(tokens[3].value, '*');
      expect(tokens[4].type, TokenType.lparen);
      expect(tokens[5].type, TokenType.identifier);
      expect(tokens[5].value, 'c');
      expect(tokens[6].type, TokenType.operator);
      expect(tokens[6].value, '-');
      expect(tokens[7].type, TokenType.identifier);
      expect(tokens[7].value, 'd');
      expect(tokens[8].type, TokenType.rparen);
      expect(tokens[9].type, TokenType.operator);
      expect(tokens[9].value, '/');
      expect(tokens[10].type, TokenType.identifier);
      expect(tokens[10].value, 'e');
    });
    test('Lexer should handle string literals correctly', () {
      final String input = '"hello world"';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 1);
      expect(tokens[0].type, TokenType.string);
      expect(tokens[0].value, 'hello world');
    });

    test('Lexer should handle function output operator correclytly', () {
      final String input = 'func someFunctionName() -> OutputType';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      expect(tokens.length, 7);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'func');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'someFunctionName');
      expect(tokens[2].type, TokenType.lparen);
      expect(tokens[3].type, TokenType.rparen);
      expect(tokens[4].type, TokenType.operator);
      expect(tokens[4].value, '-');
      expect(tokens[5].type, TokenType.operator);
      expect(tokens[5].value, '>');
      expect(tokens[6].type, TokenType.identifier);
      expect(tokens[6].value, 'OutputType');
    });

    test('Lexer should handle function declaration with arguments', () {
      final String input = 'func myFunc(x: int, y: string) { }';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 13);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'func');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'myFunc');
      expect(tokens[2].type, TokenType.lparen);
      expect(tokens[3].type, TokenType.identifier);
      expect(tokens[3].value, 'x');
      expect(tokens[4].type, TokenType.colon);
      expect(tokens[5].type, TokenType.identifier);
      expect(tokens[5].value, 'int');
      expect(tokens[6].type, TokenType.comma);
      expect(tokens[7].type, TokenType.identifier);
      expect(tokens[7].value, 'y');
      expect(tokens[8].type, TokenType.colon);
      expect(tokens[9].type, TokenType.identifier);
      expect(tokens[9].value, 'string');
      expect(tokens[10].type, TokenType.rparen);
      expect(tokens[11].type, TokenType.lbrace);
      expect(tokens[12].type, TokenType.rbrace);
    });
    test('Lexer should handle function declaration with body', () {
      final String input = 'func myFunc() { }';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 6);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'func');
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'myFunc');
      expect(tokens[2].type, TokenType.lparen);
      expect(tokens[3].type, TokenType.rparen);
      expect(tokens[4].type, TokenType.lbrace);
    });

    // Test intendation value for nested functions
    test('Lexer should handle intendation value for nested functions', () {
      final String input = '''
func myFunc():
	func nestedFunc():
		print("Hello, World!")
	return 0
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();

      expect(tokens.length, 20);
      expect(tokens[0].type, TokenType.identifier);
      expect(tokens[0].value, 'func');
      expect(tokens[0].currentIndentation, 0);
      expect(tokens[0].column, 0);
      expect(tokens[1].type, TokenType.identifier);
      expect(tokens[1].value, 'myFunc');
      expect(tokens[1].currentIndentation, 0);
      expect(tokens[2].type, TokenType.lparen);
      expect(tokens[3].type, TokenType.rparen);
      expect(tokens[4].type, TokenType.colon);
      expect(tokens[5].type, TokenType.indentation);
      expect(tokens[6].type, TokenType.identifier);
      expect(tokens[6].value, 'func');
      expect(tokens[6].currentIndentation, 1);
      expect(tokens[7].type, TokenType.identifier);
      expect(tokens[7].value, 'nestedFunc');
      expect(tokens[7].currentIndentation, 1);
      expect(tokens[8].type, TokenType.lparen);
      expect(tokens[9].type, TokenType.rparen);
    });
  });
}
