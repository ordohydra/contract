import 'ast_node.dart';

class ASTReturnNode implements ASTNode {
  final ASTNode value;

  ASTReturnNode(this.value);
}
