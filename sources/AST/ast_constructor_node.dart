import 'ast_node.dart';
import 'ast_parameter_node.dart';

class ASTConstructorNode implements ASTNode {
  final List<ASTParameterNode> args;
  final List<ASTNode> body;

  ASTConstructorNode(this.args, this.body);
}
