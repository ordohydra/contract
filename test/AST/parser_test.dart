import '../../sources/AST/ast_parser.dart';
import '../../sources/AST/lexer.dart';
import '../../sources/AST/token.dart';
import 'package:test/test.dart';

void main() {
  group('ASTParser Tests', () {
    test('Parser should handle function declaration', () {
      final String input = 'func myFunc() -> int { }';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
    test('Parser should handle function declaration without return type', () {
      final String input = 'func myFunc() { }';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
    test('Parser should handle function declaration with body', () {
      final String input = 'func myFunc() -> int { func otherFunc() {} }';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
    test('Parser should handle function declaration with arguments', () {
      final String input = 'func myFunc(arg1: int, arg2: string) { }';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
  });
}
