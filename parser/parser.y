%language "C"
%{
// #include "lexer.h"
// #include "parser.h"
extern int yylex();
#ifdef __cplusplus
#include <bits/stdc++.h>
void yyerror(std::string s);
#else
void yyerror(char *s);
#endif
%}

%token NUMBER
%token EOL
%%

calclist:| calclist NUMBER EOL {return 0;}

%%