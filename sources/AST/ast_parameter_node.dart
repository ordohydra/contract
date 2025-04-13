import 'ast_node.dart';

class ASTParameterNode implements ASTNode {
  final String name;
  final String type;

  ASTParameterNode(this.name, this.type);
}
