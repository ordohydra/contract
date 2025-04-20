import 'ast_node.dart';

class ASTNumberNode implements ASTNode {
  final num value;

  ASTNumberNode(this.value);
}
