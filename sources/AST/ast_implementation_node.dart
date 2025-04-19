import 'ast_constructor_node.dart';
import 'ast_node.dart';
import 'ast_function_node.dart';
import 'ast_variable_node.dart';

class ASTImplementationNode implements ASTNode {
  final String name;
  final String contractName;
  final List<ASTVariableNode> fields;
  final ASTConstructorNode? constructor;
  final List<ASTFunctionNode> methods;

  ASTImplementationNode(
    this.name,
    this.contractName,
    this.fields,
    this.constructor,
    this.methods,
  );
}
