import 'ast_node.dart';

class ASTLiteralNode implements ASTNode {
  final dynamic value;

  ASTLiteralNode(this.value);
}
