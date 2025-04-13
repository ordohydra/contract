import 'ast_node.dart';

class ASTIfNode implements ASTNode {
  final ASTNode condition;
  final ASTNode thenBranch;
  final ASTNode? elseBranch;

  ASTIfNode(this.condition, this.thenBranch, [this.elseBranch]);
}
