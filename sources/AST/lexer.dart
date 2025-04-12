import 'token.dart';
import 'string_utils.dart';

class Lexer {
  final String source;
  int position = 0;
  int line = 1;
  int column = 1;

  Lexer(this.source);

  Token nextToken() {
    while (position < source.length) {
      final char = source[position];

      if (isWhitespace(char)) {
        if (char == '\n') {
          line++;
          column = 1;
        } else {
          column++;
        }
        position++;
        continue;
      }

      if (char == '#') {
        while (position < source.length && source[position] != '\n') {
          position++;
        }
        continue;
      }

      if (isDigit(char) ||
          (char == '.' && isDigit(source[position + 1]) == true)) {
        int start = position;
        while (position < source.length &&
            (isDigit(source[position]) || source[position] == '.')) {
          position++;
        }
        return Token.number(
          double.tryParse(source.substring(start, position)) ?? 0,
        );
      }

      if (isAlphanumeric(char)) {
        int start = position;
        while (position < source.length && isAlphanumeric(source[position])) {
          position++;
        }
        return Token.identifier(source.substring(start, position));
      }

      if (char == '"') {
        position++;
        int start = position;
        while (position < source.length && source[position] != '"') {
          if (source[position] == '\\') {
            position++;
          }
          position++;
        }
        if (position < source.length) {
          position++; // Skip the closing quote
        }
        return Token.string(source.substring(start, position - 1));
      }

      switch (char) {
        case '(':
          position++;
          return Token.lparen;
        case ')':
          position++;
          return Token.rparen;
        case '{':
          position++;
          return Token.lbrace;
        case '}':
          position++;
          return Token.rbrace;
        case ':':
          position++;
          return Token.colon;
        case '=':
          position++;
          return Token.assign;
        case ',':
          position++;
          return Token.comma;
        case '+':
        case '-':
        case '*':
        case '/':
        case '%':
        case '<':
        case '>':
          position++;
          return Token.operator(char);
        default:
          throw Exception(
            'Unexpected character at line $line, column $column: $char',
          );
      }
    }
    return Token.eof;
  }

  List<Token> tokenize() {
    final List<Token> tokens = [];
    Token token;

    do {
      token = nextToken();
      if (token.type != TokenType.eof) {
        tokens.add(token);
      }
    } while (token.type != TokenType.eof);

    return tokens;
  }
}
