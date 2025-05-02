import '../../sources/AST/ast_implementation_node.dart';
import '../../sources/AST/ast_number_node.dart';
import '../../sources/AST/ast_parser.dart';
import '../../sources/AST/ast_function_node.dart';
import '../../sources/AST/ast_contract_node.dart';
import '../../sources/AST/ast_variable_node.dart';
import '../../sources/AST/lexer.dart';
import '../../sources/AST/token.dart';
import '../../sources/AST/ast_return_node.dart';
import '../../sources/AST/ast_call_node.dart';
import '../../sources/AST/ast_string_node.dart';
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
      final nodes = parser.parse(0);

      expect(nodes.length, equals(1));
      expect(nodes[0], isA<ASTFunctionNode>());
    });
    test('Parser should handle function declaration without return type', () {
      final String input = '''
func main():
    print("Hello world")
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse(0);

      expect(nodes.length, 1);
      expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');

      final ASTFunctionNode functionNode = nodes[0] as ASTFunctionNode;
      expect(functionNode.returnType, isNull);
      expect(functionNode.name, 'main');
      expect(functionNode.args.length, 0);
      expect(functionNode.body.length, 1);
      expect(functionNode.body[0].runtimeType.toString(), 'ASTCallNode');
      ASTCallNode callNode = functionNode.body[0] as ASTCallNode;
      expect(callNode.functionName, 'print');
      expect(callNode.arguments.length, 1);
      expect(callNode.arguments[0].runtimeType.toString(), 'ASTStringNode');
      expect((callNode.arguments[0] as ASTStringNode).value, 'Hello world');
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
      final nodes = parser.parse(0);

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
      final nodes = parser.parse(0);

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
        final nodes = parser.parse(0);

        expect(nodes.length, 1);
        expect(nodes[0].runtimeType.toString(), 'ASTFunctionNode');
        final ASTFunctionNode functionNode = nodes[0] as ASTFunctionNode;
        expect(functionNode.returnType, 'int');
        expect(functionNode.name, 'myFunc');
        expect(functionNode.args.length, 2);
        expect(functionNode.body.length, 3);
        expect(functionNode.body[0].runtimeType.toString(), 'ASTFunctionNode');
        expect(functionNode.body[1].runtimeType.toString(), 'ASTFunctionNode');
        expect(functionNode.body[2].runtimeType.toString(), 'ASTReturnNode');
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
      final nodes = parser.parse(0);

      expect(nodes.length, equals(1));
      expect(nodes[0], isA<ASTContractNode>());
      final ASTContractNode contractNode = nodes[0] as ASTContractNode;
      expect(contractNode.methods.length, 1);
      final ASTFunctionNode functionNode = contractNode.methods[0];
      expect(functionNode.returnType, 'int');
      expect(functionNode.name, 'myFunc');
      expect(functionNode.args.length, 0);
    });

    // Test variable declaration
    test('Parser should handle variable declaration', () {
      final String input = '''
var myVar: Int = 42
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse(0);
      expect(nodes.length, equals(1));
      expect(nodes[0], isA<ASTVariableNode>());
      final ASTVariableNode variableNode = nodes[0] as ASTVariableNode;
      expect(variableNode.name, 'myVar');
      expect(variableNode.type, 'Int');
      expect(variableNode.value, isA<ASTNumberNode>());
      final ASTNumberNode numberNode = variableNode.value as ASTNumberNode;
      expect(numberNode.value, 42);
    });

    // Test variable declarations inside a function
    test('Parser should handle variable declaration inside a function', () {
      final String input = '''
func myFunc():
	var myVar: Int = 42
	var anotherVar: String = "Hello"
	return myVar
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse(0);

      expect(nodes.length, equals(1));
      expect(nodes[0], isA<ASTFunctionNode>());
      final ASTFunctionNode functionNode = nodes[0] as ASTFunctionNode;
      expect(functionNode.body.length, 3);
      expect(functionNode.body[0], isA<ASTVariableNode>());
      expect(functionNode.body[1], isA<ASTVariableNode>());
      expect(functionNode.body[2], isA<ASTReturnNode>());
    });
    // Test variable declarations inside a contract
    test('Parser should handle variable declaration inside a contract', () {
      final String input = '''
impl MyImplementation of MyInterface:
    var myVar: Int = 42
    func myFunc():
        return myVar
''';
      final Lexer lexer = Lexer(input);
      final List<Token> tokens = lexer.tokenize();
      final ASTParser parser = ASTParser(tokens);
      final nodes = parser.parse(0);

      expect(nodes.length, equals(1));
      expect(nodes[0], isA<ASTImplementationNode>());
      final ASTImplementationNode implementationNode =
          nodes[0] as ASTImplementationNode;
      expect(implementationNode.fields.length, 1);
      expect(implementationNode.methods.length, 1);
      expect(implementationNode.methods[0], isA<ASTFunctionNode>());
    });
  });
}
