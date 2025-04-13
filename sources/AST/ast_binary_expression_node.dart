import 'ast_node.dart';

class ASTBinaryExpressionNode implements ASTNode {
  final ASTNode left;
  final String operator;
  final ASTNode right;

  ASTBinaryExpressionNode(this.left, this.operator, this.right);
}
