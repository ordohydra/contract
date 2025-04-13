import 'dart:io';
import '../sources/AST/ast_node.dart';
import '../sources/AST/ast_parser.dart';
import '../sources/AST/translator.dart';
import '../sources/AST/ast_program_node.dart';
import '../sources/AST/lexer.dart';
import '../sources/AST/token.dart';

void main(List<String> arguments) {
  if (arguments.length < 2) {
    print('Usage: dart main.dart <input_file> <output_file>');
    exit(1);
  }

  final String inputFile = arguments[0];
  final String outputFile = arguments[1];

  try {
    // Read the source code from the input file.
    final String sourceCode = File(inputFile).readAsStringSync();

    // Tokenize the source code.
    final Lexer lexer = Lexer(sourceCode);
    final List<Token> tokens = lexer.tokenize();

    // Parse the tokens into an AST.
    final ASTParser parser = ASTParser(tokens);
    final List<ASTNode> declarations = parser.parse();

    // Wrap the parsed nodes into an ASTProgramNode.
    final ASTProgramNode programNode = ASTProgramNode(declarations);

    // Translate the AST into Dart code.
    final Translator translator = Translator();
    final String dartCode = translator.translate(programNode);

    // Write the translated Dart code to the output file.
    File(outputFile).writeAsStringSync(dartCode);

    print('Translation successful! Output written to $outputFile');
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
