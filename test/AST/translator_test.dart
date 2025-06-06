import 'package:test/test.dart';
import '../../sources/AST/ast_call_node.dart';
import '../../sources/AST/ast_name_node.dart';
import '../../sources/AST/ast_constructor_node.dart';
import '../../sources/AST/ast_number_node.dart';
import '../../sources/AST/ast_parameter_node.dart';
import '../../sources/AST/translator.dart';
import '../../sources/AST/ast_program_node.dart';
import '../../sources/AST/ast_function_node.dart';
import '../../sources/AST/ast_contract_node.dart';
import '../../sources/AST/ast_implementation_node.dart';
import '../../sources/AST/ast_variable_node.dart';
import '../../sources/AST/ast_literal_node.dart';
import '../../sources/AST/ast_return_node.dart';
import '../../sources/AST/ast_binary_expression_node.dart';
import '../../sources/AST/ast_string_node.dart';

void main() {
  group('Translator Tests', () {
    test('Translate a simple function', () {
      final functionNode = ASTFunctionNode('square', [], [
        ASTReturnNode(
          ASTBinaryExpressionNode(ASTLiteralNode(5), '*', ASTLiteralNode(5)),
        ),
      ], 'int');

      final translator = Translator();
      final result = translator.translate(functionNode);

      expect(result, 'int square() {\nreturn 5 * 5;\n}');
    });

    test('Translate a contract', () {
      final contractNode = ASTContractNode('GeometryFigure', [
        ASTFunctionNode('square', [], [], 'double'),
      ]);

      final translator = Translator();
      final result = translator.translate(contractNode);

      expect(
        result,
        'abstract class GeometryFigure {\ndouble square() {\n\n}\n}\n',
      );
    });

    test('Translate an implementation', () {
      final implementationNode = ASTImplementationNode(
        'Rectangle',
        'GeometryFigure',
        [
          ASTVariableNode('width', 'Double', ASTNumberNode(2)),
          ASTVariableNode('height', 'Double', ASTNumberNode(3)),
        ],
        ASTConstructorNode([
          ASTParameterNode('width', 'Double'),
          ASTParameterNode('height', 'Double'),
        ], []),
        [
          ASTFunctionNode('square', [], [
            ASTReturnNode(
              ASTBinaryExpressionNode(
                ASTNameNode('width'),
                '*',
                ASTNameNode('height'),
              ),
            ),
          ], 'double'),
        ],
      );

      final translator = Translator();
      final result = translator.translate(implementationNode);

      expect(result, '''
class Rectangle implements GeometryFigure {
double width = 2;
double height = 3;

init(this.width, this.height) {\n\n}

double square() {
return width * height;
}
}
''');
    });

    test('Translate a program with multiple declarations', () {
      final programNode = ASTProgramNode([
        ASTContractNode('GeometryFigure', [
          ASTFunctionNode('square', [], [], 'double'),
        ]),
        ASTImplementationNode(
          'Rectangle',
          'GeometryFigure',
          [
            ASTVariableNode('width', 'double', ASTNumberNode(2)),
            ASTVariableNode('height', 'double', ASTNumberNode(3)),
          ],
          ASTConstructorNode([
            ASTParameterNode('width', 'double'),
            ASTParameterNode('height', 'double'),
          ], []),
          [
            ASTFunctionNode('square', [], [
              ASTReturnNode(
                ASTBinaryExpressionNode(
                  ASTNameNode('width'),
                  '*',
                  ASTNameNode('height'),
                ),
              ),
            ], 'double'),
          ],
        ),
      ]);

      final translator = Translator();
      final result = translator.translate(programNode);

      expect(result, '''
abstract class GeometryFigure {
double square() {

}
}


class Rectangle implements GeometryFigure {
double width = 2;
double height = 3;

init(this.width, this.height) {\n\n}

double square() {
return width * height;
}
}\n''');
    });

    // Test trivial program that prints "Hello, World!"
    test('Translate a trivial program', () {
      final programNode = ASTProgramNode([
        ASTFunctionNode('main', [], [
          //ASTReturnNode(ASTStringNode('Hello, World!')),
          ASTCallNode('print', [ASTStringNode('Hello, World!')]),
        ], null),
      ]);

      final translator = Translator();
      final result = translator.translate(programNode);

      expect(result, '''
void main() {
print("Hello, World!");
}''');
    });
  });
}
