#pragma once
#include "bits/allds.hpp"
#include <bits/stdc++.h>

int yyparse();

static inline pNode new_node(int lineno, const Token &token, int argc, ...) {
  std::cout<<"new_node():lineno="<<lineno<<";token="<<token.get_attribute()<<std::endl;
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
  std::cout << "TN-" << current_node->data_->get_token_name() << ": ";
  if (current_node->data_->get_token_name() == NOT_TOKEN) {
    std::cout << "(" << current_node->lineno_ << ")";
  } else {
    std::cout << ": " << current_node->data_->get_attribute();
  }
  std::cout << "\n";
  preordered_traverse(current_node->child_, height + 1);
  preordered_traverse(current_node->next_, height);
}

extern pNode root;
#define YYSTYPE pNode