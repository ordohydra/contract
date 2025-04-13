import 'ast_node.dart';
import 'ast_parameter_node.dart';

class ASTFunctionNode implements ASTNode {
  final String name;
  final List<ASTParameterNode> args;
  final List<ASTNode> body;
  final String? returnType;

  ASTFunctionNode(this.name, this.args, this.body, this.returnType);
}
