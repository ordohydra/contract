import 'ast_node.dart';

class ASTProgramNode implements ASTNode {
  final List<ASTNode> declarations;

  ASTProgramNode(this.declarations);
}
