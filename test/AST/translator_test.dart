import 'package:test/test.dart';
import '../../sources/AST/ast_name_node.dart';
import '../../sources/AST/translator.dart';
import '../../sources/AST/ast_program_node.dart';
import '../../sources/AST/ast_function_node.dart';
import '../../sources/AST/ast_contract_node.dart';
import '../../sources/AST/ast_implementation_node.dart';
import '../../sources/AST/ast_variable_node.dart';
import '../../sources/AST/ast_literal_node.dart';
import '../../sources/AST/ast_return_node.dart';
import '../../sources/AST/ast_binary_expression_node.dart';

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
          ASTVariableNode('width', 'double', false),
          ASTVariableNode('height', 'double', false),
        ],
        'Rectangle(this.width, this.height);',
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
final double width;
final double height;

Rectangle(this.width, this.height);

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
            ASTVariableNode('width', 'double', false),
            ASTVariableNode('height', 'double', false),
          ],
          'Rectangle(this.width, this.height);',
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
final double width;
final double height;

Rectangle(this.width, this.height);

double square() {
return width * height;
}
}\n''');
    });
  });
}
