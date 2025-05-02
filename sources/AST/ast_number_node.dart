import 'ast_node.dart';

class ASTNumberNode implements ASTNode {
  final num value;

  ASTNumberNode(this.value);
}

extension ASTNumberNodeExtension on ASTNumberNode {
  @override
  String asString() {
    final intValue = value.toInt();
    final doubleValue = value.toDouble();

    if (intValue == doubleValue) {
      return intValue.toString();
    } else {
      return doubleValue.toString();
    }
  }
}
