import 'ast_node.dart';

class ASTAssignmentNode implements ASTNode {
  final String variableName;
  final ASTNode value;

  ASTAssignmentNode(this.variableName, this.value);
}
