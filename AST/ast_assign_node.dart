import 'ast_node.dart';

class ASTAssignNode implements ASTNode {
  final ASTNode target;
  final ASTNode value;

  ASTAssignNode(this.target, this.value);
}
