%{ 
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
%} 

letter  [a-zA-Z_$]
digit [0-9]
ws [ \t\r\f\v]+



%% 

"while"  { return WHILE;}
"for"    { return FOR;}
"if"     { return IF;}
"else"   { return ELSE;}
"void"   { return VOID;}
"elif"   { return ELIF;}
"break"  { return BREAK;}
"continue"  {return CONTINUE;}
"flash"  { return FLASH;}
"return"  { return RETURN;} 
"true"			{yylval.dval = 1; return BOOL_TOKEN;}
"false"			{yylval.dval = 0; return BOOL_TOKEN;}
"input"         {return INPUT;}
"var"           {return VAR;}

"("           {return LRB;}
")"           {return RRB;}
"{"           {return LCB;}
"}"           {return RCB;}         
"["           {return LSB;}           
"]"           {return RSB;}
";"           {return SCOL;}
","           {return yytext[0];}
"."           {return yytext[0];}

"+"             {yylval.cValue = yytext[0]; return ADD_OP;}
"-"             {yylval.cValue = yytext[0]; return SUB_OP;}
"*"             {yylval.cValue = yytext[0]; return MUL_OP;}
"/"             {yylval.cValue = yytext[0]; return DIV_OP;}
"%"    			{yylval.cValue = yytext[0]; return REM_OP;}	
"="				{yylval.cValue = yytext[0]; return ASSIGN_OP;}
"=="                          {yylval.cValue = yytext[0]; return EQUAL_OP;}
"!="                          {yylval.cValue = yytext[0]; return NOTEQUAL_OP;}
">"                           {yylval.cValue = yytext[0]; return GT_OP;}
"<"                           {yylval.cValue = yytext[0]; return LT_OP;}
"<="                          {yylval.cValue = yytext[0]; return LE_OP;}
">="			                    {yylval.cValue = yytext[0]; return GE_OP;}
"&&"                          {yylval.cValue = yytext[0]; return AND_OP;}
"||"                          {yylval.cValue = yytext[0]; return OR_OP;}
"->"                          {yylval.cValue = yytext[0]; return SPL;}
"!"			      {yylval.cValue = yytext[0]; return NOT_OP;}
{ws}                ;


\'.\'			                                                    {insert(symboltable, yytext, "CHARACTER_TOKEN"); yylval.cValue = yytext[0]; return CHARACTER_TOKEN;}

\'.*\'			                                                    {insert(symboltable, yytext, "STRING_TOKEN"); strcpy(yylval.lexeme, yytext); return STRING_TOKEN;}

{digit}+				                                            {insert(symboltable, yytext, "INTEGER_TOKEN"); yylval.dValue = atoi(yytext); return INTEGER_TOKEN;}

{digit}+(\.{digit}+) 		 	                                    {insert(symboltable, yytext, "FLOAT_TOKEN"); yylval.fValue = atoi(yytext); return FLOAT_TOKEN;}

{letter}({letter}|{digit})*|({letter}+\.)+{letter}+ 				{insert(symboltable, yytext, "IDENTIFIER_TOKEN"); return IDENTIFIER_TOKEN; }

\/\/(.*) ;					

. 		                        { yyerror("Unknown character"); }  
%% 
  
