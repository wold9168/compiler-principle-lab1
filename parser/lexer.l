%option noyywrap
/* %option nounput noinput batch debug */
/* %option yylineno */

%{
#include <bits/stdc++.h>
#include "bits/allds.hpp"
// #include "parser.h"
extern int yylineno;
%}

BLANK [\t ]
LINEBREAK \n

CONST_INT_DEC 0|([1-9][0-9]*)
CONST_INT_HEX 0(x|X)[0-9a-fA-F]+
CONST_INT_OCT 0[0-7]+
CONST_FLOAT_NUMBER [0-9]+"."[0-9]+
CONST_FLOAT_E (([0-9]*.[0-9]+)|([0-9]+.[0-9]*))[eE][+-]?([0-9]+)

DELIMITER_SEMI ";"
OPERATOR_COMMA ","
OPERATOR_ASSIGNOP =
OPERATOR_RELOP_LT <
OPERATOR_RELOP_RT >
OPERATOR_RELOP_LE <=
OPERATOR_RELOP_RE >=
OPERATOR_RELOP_EQ ==
OPERATOR_RELOP_NE !=
OPERATOR_PLUS "+"
OPERATOR_MINUS "-"
OPERATOR_STAR "*"
OPERATOR_DIV "/"
OPERATOR_AND "&&"
OPERATOR_OR "||"
OPERATOR_DOT "."
OPERATOR_NOT "!"
KEYWORD_TYPE int|float
DELIMITER_LP "("
DELIMITER_RP ")"
DELIMITER_LB "["
DELIMITER_RB "]"
DELIMITER_LC "{"
DELIMITER_RC "}"
KEYWORD_STRUCT "struct"
KEYWORD_RETURN "return"
KEYWORD_IF "if"
KEYWORD_ELSE "else"
KEYWORD_WHILE "while"

ID [_[:alpha:]]([_[:alnum:]])*

LEX_ERROR .
%%

{BLANK} {;}
{LINEBREAK} {++yylineno;}

{CONST_INT_DEC} {append_to_global_token_list(INT,yytext);}
{CONST_INT_HEX} {append_to_global_token_list(INT,yytext);}
{CONST_INT_OCT} {append_to_global_token_list(INT,yytext);}
{CONST_FLOAT_NUMBER} {append_to_global_token_list(FLOAT,yytext);}
{CONST_FLOAT_E} {append_to_global_token_list(FLOAT,yytext);}

{DELIMITER_SEMI} {append_to_global_token_list(SEMI,yytext);}
{OPERATOR_COMMA} {append_to_global_token_list(COMMA,yytext);}
{OPERATOR_ASSIGNOP} {append_to_global_token_list(ASSIGNOP,yytext);}
{OPERATOR_RELOP_LT} {append_to_global_token_list(RELOP,yytext);}
{OPERATOR_RELOP_RT} {append_to_global_token_list(RELOP,yytext);}
{OPERATOR_RELOP_LE} {append_to_global_token_list(RELOP,yytext);}
{OPERATOR_RELOP_RE} {append_to_global_token_list(RELOP,yytext);}
{OPERATOR_RELOP_EQ} {append_to_global_token_list(RELOP,yytext);}
{OPERATOR_RELOP_NE} {append_to_global_token_list(RELOP,yytext);}
{OPERATOR_PLUS} {append_to_global_token_list(PLUS,yytext);}
{OPERATOR_MINUS} {append_to_global_token_list(MINUS,yytext);}
{OPERATOR_STAR} {append_to_global_token_list(STAR,yytext);}
{OPERATOR_DIV} {append_to_global_token_list(DIV,yytext);}
{OPERATOR_AND} {append_to_global_token_list(AND,yytext);}
{OPERATOR_OR} {append_to_global_token_list(OR,yytext);}
{OPERATOR_DOT} {append_to_global_token_list(DOT,yytext);}
{OPERATOR_NOT} {append_to_global_token_list(NOT,yytext);}
{KEYWORD_TYPE} {append_to_global_token_list(TYPE,yytext);}
{DELIMITER_LP} {append_to_global_token_list(LP,yytext);}
{DELIMITER_RP} {append_to_global_token_list(RP,yytext);}
{DELIMITER_LB} {append_to_global_token_list(LB,yytext);}
{DELIMITER_RB} {append_to_global_token_list(RB,yytext);}
{DELIMITER_LC} {append_to_global_token_list(LC,yytext);}
{DELIMITER_RC} {append_to_global_token_list(RC,yytext);}
{KEYWORD_STRUCT} {append_to_global_token_list(STRUCT,yytext);}
{KEYWORD_RETURN} {append_to_global_token_list(RETURN,yytext);}
{KEYWORD_IF} {append_to_global_token_list(IF,yytext);}
{KEYWORD_ELSE} {append_to_global_token_list(ELSE,yytext);}
{KEYWORD_WHILE} {append_to_global_token_list(WHILE,yytext);}

{ID} {append_to_global_token_list(ID,yytext);}

{LEX_ERROR} {
    fprintf(stderr,"Error type A at Line %d: Lexical analyser encountered unexpected '%s' \n",yylineno,yytext);
}

%%