import 'ast_node.dart';

class ASTCallNode implements ASTNode {
  final String functionName;
  final List<ASTNode> arguments;

  ASTCallNode(this.functionName, this.arguments);
}
