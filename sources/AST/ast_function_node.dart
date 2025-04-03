import 'ast_node.dart';

class ASTFunctionNode implements ASTNode {
  final String name;
  final List<ASTNode> args;
  final List<ASTNode> body;

  ASTFunctionNode(this.name, this.args, this.body);
}
