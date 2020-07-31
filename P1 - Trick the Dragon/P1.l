%{
	#include <stdio.h>
	#include "P1.tab.h"
	#include <string.h>
%}

digit [0-9]
integer (0|([1-9]{digit}*))
space "\t"|"\n"|"\r"|"\f"|" "
identifier [a-zA-Z][a-zA-Z0-9_]*

%% 
"//".* {;}
"class" {return Class;}
"public" {return Public;}
"static" {return Static;}
"void" {return Void;}
"main" {return Main;}
"String" {return STring;}
"System.out.println" {return Print;}
"extends" {return Extends;}
"return" {return Return;}
"int" {return Int;} 
"boolean" {return BOOlean;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"length" {return Length;}
"true" {return True;}
"false" {return False;}
"this" {return This;}
"new" {return New;}
"#define" {return Define;}
"{" {return Ocurlbrac;}
"}" {return Ccurlbrac;}
"["	{return Osqbrac;}
"]" {return Csqbrac;}
"(" {return Obrac;}
")" {return Cbrac;}
"&&" {return And;}
"||" {return Or;}
"!=" {return Notequal;}
"<=" {return Lessthanequal;}
"." {return Dot;}
"," {return Comma;}
"!"	{return Exclaim;}
"+" {return Plus;}
"-" {return Minus;}
"*" {return Mul;}
"/" {return Div;}
";" {return End;}
"=" {return Equals;}
{identifier} {yylval.identifier = strdup(yytext); return Identifier;}
{integer} {yylval.integer = strdup(yytext); return Integer;}
{space} {;}
%%

/* main()
{
  printf("Enter the input:\n");
  yylex();
}*/
