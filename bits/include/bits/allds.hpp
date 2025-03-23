#pragma once
#include <bits/stdc++.h>

enum TokenType {
  NOT_TOKEN,
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
  // Token(const Token & t) : token_name_(t.get_token_name()),
  // attribute_(t.get_attribute()) {}
  //
  // use default copy constructor function
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
      std::cout << "[Debug] [global_token_list.index:" << index++ << "] \t"
                << "token_name: " << to.get_token_name()
                << ", attribute: " << to.get_attribute() << "\n";
    }
  }
};

extern TokenList global_token_list;

inline int append_to_global_token_list(enum TokenType t,
                                       const std::string &attribute) {
  global_token_list.read(t, attribute);
  return 0;
}

struct Node {
  int lineno_;

  Token *data_;

  struct Node *child_;
  struct Node *next_;
};

typedef Node *pNode;

static inline pNode new_node(int lineno, const Token &token, int argc, ...) {
  pNode current_node = nullptr;
  current_node = new Node();
  assert(current_node != nullptr);
  current_node->data_ = new Token(token);
  assert(current_node->data_ != nullptr);
  current_node->lineno_ = lineno;
  va_list va;
  va_start(va, argc);
  pNode temp_node = va_arg(va, pNode);
  current_node->child_ = temp_node;
  for (int i = 1; i < argc; ++i) {
    temp_node->next_ = va_arg(va, pNode);
    if (temp_node->next_ != nullptr)
      temp_node = temp_node->next_;
  }
  va_end(va);
  return current_node;
}

static inline pNode new_token_node(int lineno, const Token &token) {
  pNode token_node = new Node();
  assert(token_node != nullptr);
  token_node->lineno_ = lineno;
  token_node->data_ = new Token(token);
  assert(token_node->data_ != nullptr);
  token_node->child_ = nullptr;
  token_node->child_ = nullptr;
  return token_node;
}
static inline pNode new_token_node(int lineno, enum TokenType t,
                                   const std::string &attribute) {
  return new_token_node(lineno, Token(t, attribute));
}

static inline void delete_node(pNode node) {
  if (node == nullptr)
    return;
  while (node->child_ != nullptr) {
    pNode temp = node->child_;
    node->child_ = temp->next_;
    delete_node(node->child_);
  }
  delete node->data_;
  delete node;
  node->data_ = nullptr;
  node = nullptr;
}

static inline void preordered_traverse(pNode current_node, int height = 0) {
  if (current_node == nullptr)
    return;
  std::string blank = "\t";
  for (int i = 0; i < height; ++i)
    std::cout << blank;
  std::cout <<"TN-"<< current_node->data_->get_token_name() << ": ";
  if (current_node->data_->get_token_name() == NOT_TOKEN) {
    std::cout << "(" << current_node->lineno_ << ")";
  }
  else {
    std::cout << ": " << current_node->data_->get_attribute();
  }
  std::cout << "\n";
  preordered_traverse(current_node->child_, height + 1);
  preordered_traverse(current_node->next_, height);
}

extern pNode root;