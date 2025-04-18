import '../../sources/AST/ast_parser.dart';
import '../../sources/AST/ast_function_node.dart';
import '../../sources/AST/ast_contract_node.dart';
import '../../sources/AST/lexer.dart';
import '../../sources/AST/token.dart';
import 'package:test/test.dart';

void main() {
  group('ASTParser Tests', () {
    test('Parser should handle function declaration', () {
      final String input = '''
func myFunc() -> int:
  return 0
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
    test('Parser should handle function declaration without return type', () {
      final String input = '''
func myFunc():
  print("Hello, World!")
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
    test('Parser should handle function declaration with body', () {
      final String input = '''
func myFunc() -> int:
  func otherFunc():
    print("Hello, World!")
  return 0
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });
    test('Parser should handle function declaration with arguments', () {
      final String input = '''
func myFunc(arg1: int, arg2: string):
  print(arg1)
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
    });

    test(
      'Parser should handle function with several functions inside whith different arguments and return type',
      () {
        final String input = '''
        func myFunc(arg1: int, arg2: string) -> int:
          func innerFunc1() -> string:
            return "Hello"
          func innerFunc2(arg: float):
            print(arg)
          return 42
      ''';
        final Lexer lexer = Lexer(input);
        final List<Token> tokens = lexer.tokenize();
        final ASTParser parser = ASTParser(tokens);
        final nodes = parser.parse();

        expect(nodes.length, 1);
        expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
        final ASTFunctionNode functionNode = nodes[0] as ASTFunctionNode;
        expect(functionNode.returnType, 'int');
        expect(functionNode.name, 'myFunc');
        expect(functionNode.args.length, 2);
      },
    );

    test('Test contract with function declaration', () {
      final String input = '''
contract MyContract:
  func myFunc() -> int:
    return 0
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse();

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTContractNode');
      final ASTContractNode contractNode = nodes[0] as ASTContractNode;
      expect(contractNode.methods.length, 1);
      final ASTFunctionNode functionNode = contractNode.methods[0];
      expect(functionNode.returnType, 'int');
      expect(functionNode.name, 'myFunc');
      expect(functionNode.args.length, 0);
    });
  });
}
