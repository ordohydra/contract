import 'ast_node.dart';

class ASTModuleNode implements ASTNode {
  final List<ASTNode> body;

  ASTModuleNode(this.body);
}
