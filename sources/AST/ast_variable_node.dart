import 'ast_node.dart';

class ASTVariableNode implements ASTNode {
  final String name;
  final String type;
  final String value;
  final bool isMutable;

  ASTVariableNode(this.name, this.type, this.value, {this.isMutable = false});
}
