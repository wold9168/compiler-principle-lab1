#pragma once
#include <bits/stdc++.h>

enum TokenType {
  INT,
  FLOAT,
  ID,
  SEMI,
  COMMA,
  ASSIGNOP,
  RELOP,
  PLUS,
  MINUS,
  STAR,
  DIV,
  AND,
  OR,
  DOT,
  NOT,
  TYPE,
  LP,
  RP,
  LB,
  RB,
  LC,
  RC,
  STRUCT,
  RETURN,
  IF,
  ELSE,
  WHILE
};

class Token {
private:
  enum TokenType token_name_;
  std::string attribute_;

public:
  Token() : token_name_(INT), attribute_("") {}
  Token(TokenType t, const std::string &a) : token_name_(t), attribute_(a) {}
  void set_token_name(enum TokenType t);
  void set_attribute(const std::string &a);
  enum TokenType get_token_name() const { return token_name_; }
  std::string get_attribute() const { return attribute_; }
};

class TokenList {
private:
  std::vector<Token> tokenlist_;

public:
  void read(enum TokenType token_name, const std::string &attribute) {
    tokenlist_.push_back(Token(token_name, attribute));
  }
  void read(const Token &t) { tokenlist_.push_back(t); }
  void traverse() {
    std::cout << "[Debug] " << "Now print the content of global token list.\n";
    int index = 0;
    for (auto to : tokenlist_) {
      std::cout << "[Debug] [global_token_list.index:"<< index++ <<"] \t"<<"token_name: " << to.get_token_name() << ", attribute: " << to.get_attribute()<<"\n";
    }
  }
};

extern TokenList global_token_list;

inline int append_to_global_token_list(enum TokenType t,
                                       const std::string &attribute) {
  global_token_list.read(t, attribute);
  return 0;
}

class AST {
private:
public:
};
