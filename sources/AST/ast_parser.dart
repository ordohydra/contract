import 'ast_constructor_node.dart';
import 'ast_contract_node.dart';
import 'ast_number_node.dart';
import 'ast_node.dart';
import 'ast_string_node.dart';
import 'ast_variable_node.dart';
import 'ast_function_node.dart';
import 'ast_parameter_node.dart';
import 'ast_return_node.dart';
import 'ast_implementation_node.dart';
import 'ast_name_node.dart';
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

  List<ASTNode> parse(int intendation) {
    List<ASTNode> nodes = [];
    while (position < tokens.length) {
      // Identifier
      if (currentToken.type == TokenType.identifier &&
          currentToken.currentIndentation == intendation) {
        if (currentToken.value == 'func') {
          nodes.add(parseFunctionDeclaration());
        } else if (currentToken.value == 'contract') {
          nodes.add(parseContractDeclaration());
        } else if (currentToken.value == 'var') {
          nodes.add(parseVariableDeclaration());
        } else if (currentToken.value == 'return') {
          nodes.add(parseReturnNode());
        } else if (currentToken.value == 'impl') {
          nodes.add(parseImplementationDeclaration());
        } else {
          break;
          //throw Exception('Unexpected identifier: ${currentToken.value}');
        }
        // Another token types
      } else if (currentToken.type == TokenType.indentation) {
        consume('indentation');
      } else if (currentToken.type == TokenType.dedentation) {
        consume('dedentation');
        break;
      } else {
        break;
        // throw Exception('Unexpected token: ${currentToken.type}');
      }
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
    while (position < tokens.length &&
        currentToken.type == TokenType.indentation) {
      final functionIndentation = currentToken.currentIndentation;
      print('functionIdnentation: $functionIndentation');
      print(
        'currentToken.currentIndentation: ${currentToken.currentIndentation}',
      );
      consume('indentation');
      final parsedNodes = parse(functionIndentation);
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
        currentToken.value as String != 'impl') {
      throw Exception('Expected "impl" keyword');
    }

    consume('impl keyword');

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
    ASTConstructorNode? constructor;

    // Check for indentation
    if (currentToken.type != TokenType.indentation) {
      throw Exception('Expected indentation after implementation declaration');
    }
    consume('indentation');

    while (currentToken.type == TokenType.identifier) {
      if (currentToken.type == TokenType.identifier &&
          currentToken.value as String == 'init') {
        constructor = parseConstructor();
      } else {
        // Parse variable declarations
        if (currentToken.type == TokenType.identifier &&
            currentToken.value as String == 'var') {
          fields.add(parseVariableDeclaration());
        } else if (currentToken.type == TokenType.identifier &&
            currentToken.value as String == 'func') {
          methods.add(parseFunctionDeclaration());
        } else {
          throw Exception('Expected "var" or "func" keyword');
        }
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
      final column = currentToken.column + 1;
      consume('indentation');
      final parsedNodes = parse(column);
      body.addAll(parsedNodes);
    }

    return ASTConstructorNode(args, body);
  }

  ASTVariableNode parseVariableDeclaration() {
    // Check for 'var' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'var') {
      throw Exception('Expected "var" keyword');
    }
    consume('var keyword');

    // Check for variable name
    if (currentToken.type != TokenType.identifier) {
      throw Exception('Expected variable name');
    }
    final variableName = currentToken.value as String;
    consume('variable name');

    // Check for colon indicating the start of the variable type
    if (currentToken.type != TokenType.colon) {
      throw Exception('Expected ":" after variable name');
    }
    consume('colon');

    // Check for variable type
    if (currentToken.type != TokenType.identifier) {
      throw Exception('Expected variable type');
    }
    final variableType = currentToken.value as String;
    consume('variable type');

    ASTNode? variableValue;
    // Check for assignment operator
    if (currentToken.type == TokenType.assign) {
      consume('assignment operator');

      // Parse the variable value and wrap it as ASTNode
      variableValue = parseVariableValue();
      if (variableValue == null) {
        throw Exception('Expected variable value');
      }
    }

    return ASTVariableNode(variableName, variableType, variableValue);
  }

  ASTNode? parseVariableValue() {
    // Implement parsing logic for variable values

    // This could be a number, string, or another ASTNode
    if (currentToken.type == TokenType.number) {
      final value = currentToken.value;
      consume('number');
      return ASTNumberNode(value);
    } else if (currentToken.type == TokenType.string) {
      final value = currentToken.value;
      consume('string');
      return ASTStringNode(value);
    }

    return null;
  }

  ASTReturnNode parseReturnNode() {
    // Check for 'return' keyword
    if (currentToken.type != TokenType.identifier ||
        currentToken.value as String != 'return') {
      throw Exception('Expected "return" keyword');
    }

    consume('return keyword');

    // Parse the return value
    ASTNode? returnValue;
    if (currentToken.type == TokenType.number) {
      final value = currentToken.value;
      consume('number');
      returnValue = ASTNumberNode(value);
    } else if (currentToken.type == TokenType.string) {
      final value = currentToken.value;
      consume('string');
      returnValue = ASTStringNode(value);
    } else if (currentToken.type == TokenType.identifier) {
      final value = currentToken.value;
      consume('identifier');
      returnValue = ASTNameNode(value);
    }

    if (returnValue == null) {
      throw Exception('Expected return value');
    }

    return ASTReturnNode(returnValue);
  }
}
