import 'ast_node.dart';
import 'ast_function_node.dart';
import 'token.dart';

class ASTParser {
  final List<Token> tokens;
  int position = 0;

  ASTParser(this.tokens);

  Token get currentToken => tokens[position];

  void consume(String consumeComment) {
    position++;
  }

  void expect(TokenType type) {
    if (currentToken.type != type) {
      throw Exception('Expected $type, but got ${currentToken.type}');
    }

    consume('token type ${type}');
  }

  List<ASTNode> parse() {
    List<ASTNode> nodes = [];
    while (position < tokens.length) {
      if (currentToken.type == TokenType.identifier) {
        if (currentToken.value == 'func') {
          nodes.add(parseFunctionDeclaration());
        }
      }

      break; // For now, we only handle function declarations
    }

    return nodes;
  }

  ASTFunctionNode parseFunctionDeclaration() {
    // Check for 'func' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'func') {
      throw Exception('Expected "func" keyword');
    }

    consume('func keyword');

    // Check for function name
    if (currentToken.type != TokenType.identifier) {
      throw Exception('Expected function name');
    }
    final functionName = currentToken.value as String;
    consume('function name');

    // Check for parentheses
    expect(TokenType.lparen);
    expect(TokenType.rparen);

    String? returnType;
    List<ASTNode> body = [];

    // Check for return type
    if (currentToken.type == TokenType.operator && currentToken.value == '-') {
      consume('arrow first part');

      if (currentToken.type == TokenType.operator &&
          currentToken.value == '>') {
        consume('arrow second part');

        if (currentToken.type != TokenType.identifier) {
          throw Exception('Expected return type');
        }

        returnType = currentToken.value as String;
        consume('return type');
      }
    }

    // Check for function body
    expect(TokenType.lbrace);

    while (currentToken.type != TokenType.rbrace) {
      final parsedNodes = parse();
      body.addAll(parsedNodes);
    }

    expect(TokenType.rbrace);

    return ASTFunctionNode(functionName, [], body, returnType);
  }
}
