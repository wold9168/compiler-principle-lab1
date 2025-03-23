%{
#include <bits/stdc++.h>
#include "bits/allds.hpp"
#define YYSTYPE pNode
#include "parser.h"
extern int yylineno;
int tokenlex(enum TokenType t, const std::string &attribute, YYSTYPE * pt_yylval);
int yycolumn = 1;
#define YY_USER_ACTION yylloc->first_line = yylloc->last_line = yylineno;
%}
%option noyywrap
/* %option nounput noinput batch debug */
%option yylineno
%option bison-bridge
%option bison-locations

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
{LINEBREAK} {++yylineno; yycolumn = 1; }

{CONST_INT_DEC} {tokenlex(INT,yytext,yylval);}
{CONST_INT_HEX} {tokenlex(INT,yytext,yylval);}
{CONST_INT_OCT} {tokenlex(INT,yytext,yylval);}
{CONST_FLOAT_NUMBER} {tokenlex(FLOAT,yytext,yylval);}
{CONST_FLOAT_E} {tokenlex(FLOAT,yytext,yylval);}

{DELIMITER_SEMI} {tokenlex(SEMI,yytext,yylval);}
{OPERATOR_COMMA} {tokenlex(COMMA,yytext,yylval);}
{OPERATOR_ASSIGNOP} {tokenlex(ASSIGNOP,yytext,yylval);}
{OPERATOR_RELOP_LT} {tokenlex(RELOP,yytext,yylval);}
{OPERATOR_RELOP_RT} {tokenlex(RELOP,yytext,yylval);}
{OPERATOR_RELOP_LE} {tokenlex(RELOP,yytext,yylval);}
{OPERATOR_RELOP_RE} {tokenlex(RELOP,yytext,yylval);}
{OPERATOR_RELOP_EQ} {tokenlex(RELOP,yytext,yylval);}
{OPERATOR_RELOP_NE} {tokenlex(RELOP,yytext,yylval);}
{OPERATOR_PLUS} {tokenlex(PLUS,yytext,yylval);}
{OPERATOR_MINUS} {tokenlex(MINUS,yytext,yylval);}
{OPERATOR_STAR} {tokenlex(STAR,yytext,yylval);}
{OPERATOR_DIV} {tokenlex(DIV,yytext,yylval);}
{OPERATOR_AND} {tokenlex(AND,yytext,yylval);}
{OPERATOR_OR} {tokenlex(OR,yytext,yylval);}
{OPERATOR_DOT} {tokenlex(DOT,yytext,yylval);}
{OPERATOR_NOT} {tokenlex(NOT,yytext,yylval);}
{KEYWORD_TYPE} {tokenlex(TYPE,yytext,yylval);}
{DELIMITER_LP} {tokenlex(LP,yytext,yylval);}
{DELIMITER_RP} {tokenlex(RP,yytext,yylval);}
{DELIMITER_LB} {tokenlex(LB,yytext,yylval);}
{DELIMITER_RB} {tokenlex(RB,yytext,yylval);}
{DELIMITER_LC} {tokenlex(LC,yytext,yylval);}
{DELIMITER_RC} {tokenlex(RC,yytext,yylval);}
{KEYWORD_STRUCT} {tokenlex(STRUCT,yytext,yylval);}
{KEYWORD_RETURN} {tokenlex(RETURN,yytext,yylval);}
{KEYWORD_IF} {tokenlex(IF,yytext,yylval);}
{KEYWORD_ELSE} {tokenlex(ELSE,yytext,yylval);}
{KEYWORD_WHILE} {tokenlex(WHILE,yytext,yylval);}

{ID} {tokenlex(ID,yytext,yylval);}

{LEX_ERROR} {
    fprintf(stderr,"Error type A at Line %d: Lexical analyser encountered unexpected '%s' \n",yylineno,yytext,yylval);
}

%%

int tokenlex(enum TokenType t, const std::string &attribute, YYSTYPE * pt_yylval) {
  append_to_global_token_list(t, attribute);
  *pt_yylval = new_token_node(yylineno, t, attribute);
  return 0;
}