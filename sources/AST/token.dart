enum TokenType {
  identifier,
  number,
  operator,
  lparen,
  rparen,
  lbrace,
  rbrace,
  colon,
  assign,
  eof,
}

class Token {
  final TokenType type;
  final dynamic value;

  const Token(this.type, [this.value]);

  static const eof = Token(TokenType.eof);
  static const lparen = Token(TokenType.lparen);
  static const rparen = Token(TokenType.rparen);
  static const lbrace = Token(TokenType.lbrace);
  static const rbrace = Token(TokenType.rbrace);
  static const colon = Token(TokenType.colon);
  static const assign = Token(TokenType.assign);
  //static const operator = Token(TokenType.operator);

  factory Token.identifier(String value) => Token(TokenType.identifier, value);
  factory Token.number(num value) => Token(TokenType.number, value);
  factory Token.operator(String value) => Token(TokenType.operator, value);
}
