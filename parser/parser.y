%language "C"
%code requires {
// #include "bits/allds.hpp"
}

%{
#include "parser/parser.hpp"
#include "parser.h"

int yylex(YYSTYPE *yylval, YYLTYPE *yylloc);
extern int yylineno;

#include <bits/stdc++.h>
void yyerror(YYLTYPE *locp, const char* s) {
    std::cerr << "Error type B at line " << locp->first_line << ": " << s <<"."<< std::endl;
}
%}
%locations
// request a pure (reentrant) parser
%define api.pure full
// enable location in error handler
%locations
// enable verbose syntax error message
%define parse.error verbose

// types

%union{
 pNode node;
}

// tokens

%token <node> INT_
%token <node> FLOAT_
%token <node> ID_
%token <node> TYPE_
%token <node> COMMA_
%token <node> DOT_
%token <node> SEMI_
%token <node> RELOP_
%token <node> ASSIGNOP_
%token <node> PLUS_ MINUS_ STAR_ DIV_
%token <node> AND_ OR_ NOT_
%token <node> LP_ RP_ LB_ RB_ LC_ RC_
%token <node> IF_
%token <node> ELSE_
%token <node> WHILE_
%token <node> STRUCT_
%token <node> RETURN_

// non-terminals

%type <node> Program ExtDefList ExtDef ExtDecList // High-level Definitions
%type <node> Specifier StructSpecifier OptTag Tag // Specifiers
%type <node> VarDec FunDec VarList ParamDec // Declarators
%type <node> CompSt StmtList Stmt // Statements
%type <node> DefList Def Dec DecList // Local Definitions
%type <node> Exp Args // Expressions

// precedence and associativity

%right ASSIGNOP_
%left OR_
%left AND_
%left RELOP_
%left PLUS_ MINUS_
%left STAR_ DIV_
%right NOT_
%left DOT_
%left LB_ RB_
%left LP_ RP_
%nonassoc LOWER_THAN_ELSE_
%nonassoc ELSE_

%%

Program: ExtDefList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Program"),1,$1);root = $$;};
ExtDefList: ExtDef ExtDefList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDefList"),2,$1,$2);}
    |  {$$ = nullptr;};
ExtDef: Specifier ExtDecList SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDef"),3,$1,$2,$3);}
    | Specifier SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDef"),2,$1,$2);}
    | Specifier FunDec CompSt  {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDef"),3,$1,$2,$3);};
ExtDecList: VarDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDecList"),1,$1);}
    | VarDec COMMA_ ExtDecList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDecList"),3,$1,$2,$3);};

Specifier: TYPE_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Specifier"),1,$1);}
    | StructSpecifier {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Specifier"),1,$1);};
StructSpecifier: STRUCT_ OptTag LC_ DefList RC_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"StructSpecifier"),5,$1,$2,$3,$4,$5);}
    | STRUCT_ Tag {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"StructSpecifier"),2,$1,$2);};
OptTag: ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"OptTag"),1,$1);}
    |  {$$ = nullptr;};
Tag: ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"OptTag"),1,$1);};

VarDec: ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDecList"),1,$1);}
    | VarDec LB_ INT_ RB_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"VarDec"),4,$1,$2,$3,$4);};
FunDec: ID_ LP_ VarList RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"FunDec"),4,$1,$2,$3,$4);}
    | ID_ LP_ RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"FunDec"),3,$1,$2,$3);};
VarList: ParamDec COMMA_ VarList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"VarList"),3,$1,$2,$3);}
    | ParamDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"VarList"),1,$1);};
ParamDec: Specifier VarDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ParamDec"),2,$1,$2);};

CompSt: LC_ DefList StmtList RC_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"CompSt"),4,$1,$2,$3,$4);};
StmtList: Stmt StmtList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),2,$1,$2);}
    |  {$$ = nullptr;};
Stmt: Exp SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),2,$1,$2);}
    | CompSt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),1,$1);}
    | RETURN_ Exp SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),3,$1,$2,$3);}
    | IF_ LP_ Exp RP_ Stmt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),5,$1,$2,$3,$4,$5);}
    | IF_ LP_ Exp RP_ Stmt ELSE_ Stmt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),7,$1,$2,$3,$4,$5,$6,$7);}
    | WHILE_ LP_ Exp RP_ Stmt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),5,$1,$2,$3,$4,$5);};

DefList: Def DefList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"DefList"),2,$1,$2);}
    |  {$$ = nullptr;};
Def: Specifier DecList SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Def"),3,$1,$2,$3);};
DecList: Dec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"DecList"),1,$1);}
    | Dec COMMA_ DecList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"DecList"),3,$1,$2,$3);};
Dec: VarDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Dec"),1,$1);}
    | VarDec ASSIGNOP_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Dec"),3,$1,$2,$3);};

Exp: Exp ASSIGNOP_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp AND_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp OR_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp RELOP_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp PLUS_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp MINUS_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp STAR_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp DIV_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | LP_ Exp RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | MINUS_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),2,$1,$2);}
    | NOT_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),2,$1,$2);}
    | ID_ LP_ Args RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),4,$1,$2,$3,$4);}
    | ID_ LP_ RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | Exp LB_ Exp RB_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),4,$1,$2,$3,$4);}
    | Exp DOT_ ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);}
    | ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),1,$1);}
    | INT_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),1,$1);}
    | FLOAT_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),1,$1);};
Args: Exp COMMA_ Args {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Args"),3,$1,$2,$3);}
    | Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Args"),1,$1);};
%%