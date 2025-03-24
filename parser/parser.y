%language "C"
%code requires {
}

%{
#include "parser.h"
#include "parser/parser.hpp"
#define YYSTYPE pNode
#include "lexer.h"
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

// %union{
//  pNode node;
// }
// tokens

%token INT_
%token FLOAT_
%token ID_
%token TYPE_
%token COMMA_
%token DOT_
%token SEMI_
%token RELOP_
%token ASSIGNOP_
%token PLUS_ MINUS_ STAR_ DIV_
%token AND_ OR_ NOT_
%token LP_ RP_ LB_ RB_ LC_ RC_
%token IF_
%token ELSE_
%token WHILE_
%token STRUCT_
%token RETURN_

// non-terminals

%type Program ExtDefList ExtDef ExtDecList // High-level Definitions
%type Specifier StructSpecifier OptTag Tag // Specifiers
%type VarDec FunDec VarList ParamDec // Declarators
%type CompSt StmtList Stmt // Statements
%type DefList Def Dec DecList // Local Definitions
%type Exp Args // Expressions

// // tokens

// %token <node> INT_
// %token <node> FLOAT_
// %token <node> ID_
// %token <node> TYPE_
// %token <node> COMMA_
// %token <node> DOT_
// %token <node> SEMI_
// %token <node> RELOP_
// %token <node> ASSIGNOP_
// %token <node> PLUS_ MINUS_ STAR_ DIV_
// %token <node> AND_ OR_ NOT_
// %token <node> LP_ RP_ LB_ RB_ LC_ RC_
// %token <node> IF_
// %token <node> ELSE_
// %token <node> WHILE_
// %token <node> STRUCT_
// %token <node> RETURN_

// // non-terminals

// %type <node> Program ExtDefList ExtDef ExtDecList // High-level Definitions
// %type <node> Specifier StructSpecifier OptTag Tag // Specifiers
// %type <node> VarDec FunDec VarList ParamDec // Declarators
// %type <node> CompSt StmtList Stmt // Statements
// %type <node> DefList Def Dec DecList // Local Definitions
// %type <node> Exp Args // Expressions

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

Program: ExtDefList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Program"),1,$1);root = $$;std::cout<<$$<<std::endl;}
ExtDefList: ExtDef ExtDefList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDefList"),2,$1,$2);std::cout<<$$<<std::endl;}
    |  {$$ = nullptr;std::cout<<$$<<std::endl;}
ExtDef: Specifier ExtDecList SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDef"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Specifier SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDef"),2,$1,$2);std::cout<<$$<<std::endl;}
    | Specifier FunDec CompSt  {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDef"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
ExtDecList: VarDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDecList"),1,$1);std::cout<<$$<<std::endl;}
    | VarDec COMMA_ ExtDecList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDecList"),3,$1,$2,$3);std::cout<<$$<<std::endl;}

Specifier: TYPE_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Specifier"),1,$1);std::cout<<$$<<std::endl;}
    | StructSpecifier {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Specifier"),1,$1);std::cout<<$$<<std::endl;}
StructSpecifier: STRUCT_ OptTag LC_ DefList RC_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"StructSpecifier"),5,$1,$2,$3,$4,$5);std::cout<<$$<<std::endl;}
    | STRUCT_ Tag {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"StructSpecifier"),2,$1,$2);std::cout<<$$<<std::endl;}
OptTag: ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"OptTag"),1,$1);std::cout<<$$<<std::endl;}
    |  {$$ = nullptr;std::cout<<$$<<std::endl;}
Tag: ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"OptTag"),1,$1);std::cout<<$$<<std::endl;}

VarDec: ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ExtDecList"),1,$1);std::cout<<$$<<std::endl;}
    | VarDec LB_ INT_ RB_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"VarDec"),4,$1,$2,$3,$4);std::cout<<$$<<std::endl;}
FunDec: ID_ LP_ VarList RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"FunDec"),4,$1,$2,$3,$4);std::cout<<$$<<std::endl;}
    | ID_ LP_ RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"FunDec"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
VarList: ParamDec COMMA_ VarList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"VarList"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | ParamDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"VarList"),1,$1);std::cout<<$$<<std::endl;}
ParamDec: Specifier VarDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"ParamDec"),2,$1,$2);std::cout<<$$<<std::endl;}

CompSt: LC_ DefList StmtList RC_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"CompSt"),4,$1,$2,$3,$4);std::cout<<$$<<std::endl;}
StmtList: Stmt StmtList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),2,$1,$2);std::cout<<$$<<std::endl;}
    |  {$$ = nullptr;std::cout<<$$<<std::endl;}
Stmt: Exp SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),2,$1,$2);std::cout<<$$<<std::endl;}
    | CompSt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),1,$1);std::cout<<$$<<std::endl;}
    | RETURN_ Exp SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | IF_ LP_ Exp RP_ Stmt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),5,$1,$2,$3,$4,$5);std::cout<<$$<<std::endl;}
    | IF_ LP_ Exp RP_ Stmt ELSE_ Stmt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),7,$1,$2,$3,$4,$5,$6,$7);std::cout<<$$<<std::endl;}
    | WHILE_ LP_ Exp RP_ Stmt {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Stmt"),5,$1,$2,$3,$4,$5);std::cout<<$$<<std::endl;}

DefList: Def DefList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"DefList"),2,$1,$2);std::cout<<$$<<std::endl;}
    |  {$$ = nullptr;std::cout<<$$<<std::endl;}
Def: Specifier DecList SEMI_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Def"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
DecList: Dec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"DecList"),1,$1);std::cout<<$$<<std::endl;}
    | Dec COMMA_ DecList {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"DecList"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
Dec: VarDec {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Dec"),1,$1);std::cout<<$$<<std::endl;}
    | VarDec ASSIGNOP_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Dec"),3,$1,$2,$3);std::cout<<$$<<std::endl;}

Exp: Exp ASSIGNOP_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp AND_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp OR_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp RELOP_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp PLUS_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp MINUS_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp STAR_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp DIV_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | LP_ Exp RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | MINUS_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),2,$1,$2);std::cout<<$$<<std::endl;}
    | NOT_ Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),2,$1,$2);std::cout<<$$<<std::endl;}
    | ID_ LP_ Args RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),4,$1,$2,$3,$4);std::cout<<$$<<std::endl;}
    | ID_ LP_ RP_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp LB_ Exp RB_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),4,$1,$2,$3,$4);std::cout<<$$<<std::endl;}
    | Exp DOT_ ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | ID_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),1,$1);std::cout<<$$<<std::endl;}
    | INT_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),1,$1);std::cout<<$$<<std::endl;}
    | FLOAT_ {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Exp"),1,$1);std::cout<<$$<<std::endl;}
Args: Exp COMMA_ Args {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Args"),3,$1,$2,$3);std::cout<<$$<<std::endl;}
    | Exp {$$ = new_node(@$.first_line,Token(NOT_TOKEN,"Args"),1,$1);std::cout<<$$<<std::endl;}
%%