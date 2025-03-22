#include "bits/allds.hpp"

void Token::set_token_name(enum TokenType t) { this->token_name_ = t; }
void Token::set_attribute(const std::string &a) { this->attribute_ = a; }

TokenList global_token_list=TokenList();

