import 'ast_node.dart';

class ASTVariableNode implements ASTNode {
  final String name;
  final String type;
  final ASTNode? value;

  ASTVariableNode(this.name, this.type, [this.value]);
}
