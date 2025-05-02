import 'ast_constructor_node.dart';
import 'ast_name_node.dart';
import 'ast_node.dart';
import 'ast_function_node.dart';
import 'ast_number_node.dart';
import 'ast_program_node.dart';
import 'ast_literal_node.dart';
import 'ast_contract_node.dart';
import 'ast_implementation_node.dart';
import 'ast_string_node.dart';
import 'ast_variable_node.dart';
import 'ast_return_node.dart';
import 'ast_binary_expression_node.dart';
import 'ast_call_node.dart';

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
    } else if (node is ASTNameNode) {
      return node.id;
    } else if (node is ASTStringNode) {
      return '"${node.value}"';
    } else if (node is ASTCallNode) {
      final args = node.arguments.map(translate).join(', ');
      return '${node.functionName}($args);';
    } else if (node is ASTNumberNode) {
      return node.asString();
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
    return 'abstract class ${node.name} {\n$methods\n}\n';
  }

  String _translateConstructor(ASTConstructorNode node) {
    final args = node.args.map((arg) => 'this.${arg.name}').join(', ');
    final body = node.body.map(translate).join('\n');
    return 'init($args) {\n$body\n}';
  }

  String _translateImplementation(ASTImplementationNode node) {
    final fields = node.fields.map(translate).join('\n');
    final methods = node.methods.map(translate).join('\n');
    final constructor =
        node.constructor != null
            ? _translateConstructor(node.constructor!)
            : '';
    return '''
class ${node.name} implements ${node.contractName} {
$fields

${constructor}

$methods
}
''';
  }

  String _translateVariable(ASTVariableNode node) {
    return '${_translateType(node.type)} ${node.name} = ${translate(node.value)};';
  }

  String _translateType(String type) {
    switch (type) {
      case 'Int':
        return 'int';
      case 'Double':
        return 'double';
      case 'String':
        return 'string';
      case 'Bool':
        return 'bool';
      default:
        return type;
    }
  }
}
