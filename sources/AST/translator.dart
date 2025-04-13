import 'ast_node.dart';
import 'ast_function_node.dart';
import 'ast_program_node.dart';
import 'ast_literal_node.dart';
import 'ast_contract_node.dart';
import 'ast_implementation_node.dart';
import 'ast_variable_node.dart';
import 'ast_return_node.dart';
import 'ast_binary_expression_node.dart';

class Translator {
  String translate(ASTNode node) {
    if (node is ASTProgramNode) {
      return node.declarations.map(translate).join('\n\n');
    } else if (node is ASTFunctionNode) {
      return _translateFunction(node);
    } else if (node is ASTContractNode) {
      return _translateContract(node);
    } else if (node is ASTImplementationNode) {
      return _translateImplementation(node);
    } else if (node is ASTVariableNode) {
      return _translateVariable(node);
    } else if (node is ASTReturnNode) {
      return 'return ${translate(node.value)};';
    } else if (node is ASTBinaryExpressionNode) {
      return '${translate(node.left)} ${node.operator} ${translate(node.right)}';
    } else if (node is ASTLiteralNode) {
      return node.value.toString();
    } else {
      throw Exception('Unknown AST node type: ${node.runtimeType}');
    }
  }

  String _translateFunction(ASTFunctionNode node) {
    final args = node.args.map((arg) => '${arg.type} ${arg.name}').join(', ');
    final returnType = node.returnType ?? 'void';
    final body = node.body.map(translate).join('\n');
    return '$returnType ${node.name}($args) {\n$body\n}';
  }

  String _translateContract(ASTContractNode node) {
    final methods = node.methods.map(translate).join('\n');
    return 'abstract class ${node.name} {\n$methods\n}';
  }

  String _translateImplementation(ASTImplementationNode node) {
    final fields = node.fields.map(translate).join('\n');
    final methods = node.methods.map(translate).join('\n');
    return '''
class ${node.name} implements ${node.contractName} {
$fields

${node.constructor}

$methods
}
''';
  }

  String _translateVariable(ASTVariableNode node) {
    final modifier = node.isMutable ? '' : 'final ';
    return '$modifier${node.type} ${node.name};';
  }
}
