enum TokenType {
  identifier,
  number,
  string,
  operator,
  lparen,
  rparen,
  lbrace,
  rbrace,
  colon,
  assign,
  comma,
  indentation,
  dedentation,
  eof,
}

class Token {
  final TokenType type;
  final dynamic value;
  final int line;
  final int column;
  final int currentIndentation;

  const Token(
    this.type, [
    this.value,
    this.line = -1,
    this.column = -1,
    this.currentIndentation = -1,
  ]);

  static const eof = Token(TokenType.eof);
  static const lparen = Token(TokenType.lparen);
  static const rparen = Token(TokenType.rparen);
  static const lbrace = Token(TokenType.lbrace);
  static const rbrace = Token(TokenType.rbrace);
  static const colon = Token(TokenType.colon);
  static const assign = Token(TokenType.assign);
  static const comma = Token(TokenType.comma);

  factory Token.identifier(
    String value,
    int line,
    int column,
    int currentIndentation,
  ) => Token(TokenType.identifier, value, line, column, currentIndentation);
  factory Token.string(String value) => Token(TokenType.string, value);
  factory Token.number(num value) => Token(TokenType.number, value);
  factory Token.operator(String value) => Token(TokenType.operator, value);
  factory Token.indentation(int line, int column) =>
      Token(TokenType.indentation, line, column);
  factory Token.dedentation(int line, int column) =>
      Token(TokenType.dedentation, line, column);
}
