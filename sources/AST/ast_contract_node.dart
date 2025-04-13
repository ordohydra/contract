import 'ast_node.dart';
import 'ast_function_node.dart';

class ASTContractNode implements ASTNode {
  final String name;
  final List<ASTFunctionNode> methods;

  ASTContractNode(this.name, this.methods);
}
