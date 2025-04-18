import 'ast_constructor_node.dart';
import 'ast_contract_node.dart';
import 'ast_node.dart';
import 'ast_variable_node.dart';
import 'ast_function_node.dart';
import 'ast_parameter_node.dart';
import 'ast_implementation_node.dart';
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
        } else if (currentToken.value == 'contract') {
          nodes.add(parseContractDeclaration());
        } else {
          // throw Exception('Unexpected identifier: ${currentToken.value}');
        }
      } else {
        // throw Exception('Unexpected token: ${currentToken.type}');
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

    String? returnType;
    List<ASTNode> body = [];
    List<ASTParameterNode> args = [];

    // Check for parentheses
    expect(TokenType.lparen);
    // Check for named arguments
    while (currentToken.type != TokenType.rparen) {
      if (currentToken.type != TokenType.identifier) {
        throw Exception('Expected argument name');
      }
      final argumentName = currentToken.value as String;
      consume('argument name');
      if (currentToken.type != TokenType.colon) {
        throw Exception('Expected ":" after argument name');
      }
      consume('colon');
      if (currentToken.type != TokenType.identifier) {
        throw Exception('Expected argument type');
      }
      final argumentType = currentToken.value as String;
      consume('argument type');

      args.add(ASTParameterNode(argumentName, argumentType));

      if (currentToken.type == TokenType.comma) {
        consume('comma');
      } else {
        break;
      }
    }

    expect(TokenType.rparen);

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

    // Check for colon indicating the start of the function body
    if (currentToken.type != TokenType.colon) {
      throw Exception('Expected ":" after function declaration');
    }
    consume('colon');

    // Parse the function body (indented block)
    while (currentToken.type == TokenType.indentation) {
      consume('indentation');
      final parsedNodes = parse();
      body.addAll(parsedNodes);
    }

    return ASTFunctionNode(functionName, args, body, returnType);
  }

  // Add parsing for ASTContractNode
  ASTContractNode parseContractDeclaration() {
    // Check for 'contract' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'contract') {
      throw Exception('Expected "contract" keyword');
    }

    consume('contract keyword');

    // Check for contract name
    if (currentToken.type != TokenType.identifier) {
      throw Exception('Expected contract name');
    }
    final contractName = currentToken.value as String;
    consume('contract name');

    // Check for colon indicating the start of the contract body
    if (currentToken.type != TokenType.colon) {
      throw Exception('Expected ":" after contract declaration');
    }
    consume('colon');

    // Parse the contract body (indented block)
    List<ASTFunctionNode> methods = [];
    while (currentToken.type == TokenType.indentation) {
      consume('indentation');
      methods.add(parseFunctionDeclaration());
    }

    return ASTContractNode(contractName, methods);
  }

  // Add parsing for ASTImplementationNode
  ASTImplementationNode parseImplementationDeclaration() {
    // Check for 'implementation' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'implementation') {
      throw Exception('Expected "implementation" keyword');
    }

    consume('implementation keyword');

    // Check for implementation name
    if (currentToken.type != TokenType.identifier) {
      throw Exception('Expected implementation name');
    }
    final implementationName = currentToken.value as String;
    consume('implementation name');

    // Check for 'of' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'of') {
      throw Exception('Expected "of" keyword');
    }
    consume('of keyword');

    // Check for contract name
    if (currentToken.type != TokenType.identifier) {
      throw Exception('Expected contract name');
    }
    final contractName = currentToken.value as String;
    consume('contract name');

    // Check for colon indicating the start of the implementation body
    if (currentToken.type != TokenType.colon) {
      throw Exception('Expected ":" after implementation declaration');
    }
    consume('colon');

    // Parse the implementation body (indented block)
    List<ASTVariableNode> fields = [];
    List<ASTFunctionNode> methods = [];
    ASTConstructorNode? constructor = null;

    while (currentToken.type == TokenType.indentation) {
      consume('indentation');
      if (currentToken.type == TokenType.identifier &&
          currentToken.value as String == 'init') {
        constructor = parseConstructor();
      } else {
        methods.add(parseFunctionDeclaration());
      }
    }

    return ASTImplementationNode(
      implementationName,
      contractName,
      fields,
      constructor,
      methods,
    );
  }

  // Add parsing for constructor
  ASTConstructorNode parseConstructor() {
    // Check for 'init' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'init') {
      throw Exception('Expected "init" keyword');
    }

    consume('init keyword');

    // Check for parentheses
    expect(TokenType.lparen);

    // Parse constructor arguments
    List<ASTParameterNode> args = [];
    while (currentToken.type != TokenType.rparen) {
      if (currentToken.type != TokenType.identifier) {
        throw Exception('Expected argument name');
      }
      final argumentName = currentToken.value as String;
      consume('argument name');
      if (currentToken.type != TokenType.colon) {
        throw Exception('Expected ":" after argument name');
      }
      consume('colon');
      if (currentToken.type != TokenType.identifier) {
        throw Exception('Expected argument type');
      }
      final argumentType = currentToken.value as String;
      consume('argument type');

      args.add(ASTParameterNode(argumentName, argumentType));

      if (currentToken.type == TokenType.comma) {
        consume('comma');
      } else {
        break;
      }
    }

    expect(TokenType.rparen);

    // Check for colon indicating the start of the constructor body
    if (currentToken.type != TokenType.colon) {
      throw Exception('Expected ":" after constructor declaration');
    }
    consume('colon');

    // Parse the constructor body (indented block)
    List<ASTNode> body = [];
    while (currentToken.type == TokenType.indentation) {
      consume('indentation');
      final parsedNodes = parse();
      body.addAll(parsedNodes);
    }

    return ASTConstructorNode(args, body);
  }
}
