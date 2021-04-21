%{
    #include <stdlib.h>
    #include <stdio.h>
    #include "symboltable.h"

    entry_t** symboltable;

    #include "lex.yy.c"

    int yyerror(char *errmsg);

%}

%union
{
    int dval;
    char lexeme[40];
    int dValue;
    float fValue;
    char cValue;
    entry_t* entry;
}

%token <entry> IDENTIFIER_TOKEN

 /* Constants */
%token <dValue> INTEGER_TOKEN
%token <cValue> CHARACTER_TOKEN
%token  STRING_TOKEN  
%token <dval> BOOL_TOKEN
%token <fValue> FLOAT_TOKEN

%token METHOD_TOKEN

 /* Arithmetic Operators */
%token ADD_OP SUB_OP MUL_OP DIV_OP REM_OP

 /* Logical and Relational operators */
%token EQUAL_OP NOTEQUAL_OP GT_OP LT_OP LE_OP GE_OP AND_OP OR_OP NOT_OP 

%token LRB RRB LCB RCB LSB RSB SCOL

 /* Short hand Expression operators */
%token ASSIGN_OP 

/* Special Character */
%token SPL

 /* Data types */
%token VAR

 /* Keywords */
%token FOR WHILE IF ELSE ELIF VOID TRUE FALSE FLASH CONTINUE BREAK RETURN INPUT

%left ','
%right ASSIGN_OP
%left OR_OP
%left AND_OP
%left EQUAL_OP NOTEQUAL_OP
%left LT_OP GT_OP LE_OP GE_OP
%left ADD_OP SUB_OP
%left MUL_OP DIV_OP REM_OP
%right NOT_OP

%start starter


%%

starter:                Declarations;

Declarations:           Declaration 
                        | Declaration Declarations ;



/* Declaration block */
Declaration:            Type Expression SCOL
                        | Expression SCOL  	
                        | FunctionCall SCOL 	
                        | Array SCOL	
                        | Type Array SCOL
                        | Function
                        | StmtList   
                        | error {printf("\nError");}
                        ;


/* Expression block */
Expression:             IDENTIFIER_TOKEN ASSIGN_OP Expression
                        | IDENTIFIER_TOKEN ASSIGN_OP FunctionCall
                        | IDENTIFIER_TOKEN ASSIGN_OP Array
                        | Array ASSIGN_OP Expression
                        | Array ASSIGN_OP Array
                        | Array ASSIGN_OP INPUT LRB RRB
                        | IDENTIFIER_TOKEN ',' Expression
                        | INTEGER_TOKEN ',' Expression
                        | IDENTIFIER_TOKEN ADD_OP Expression
                        | IDENTIFIER_TOKEN SUB_OP Expression
                        | IDENTIFIER_TOKEN MUL_OP Expression
                        | IDENTIFIER_TOKEN DIV_OP Expression	
                        | INTEGER_TOKEN ADD_OP Expression
                        | INTEGER_TOKEN SUB_OP Expression
                        | INTEGER_TOKEN MUL_OP Expression
                        | INTEGER_TOKEN DIV_OP Expression	
                        | LRB Expression RRB
                        | SUB_OP LRB Expression RRB
                        | SUB_OP INTEGER_TOKEN
                        | SUB_OP IDENTIFIER_TOKEN
                        | INTEGER_TOKEN
                        | IDENTIFIER_TOKEN
                        ;

/* Function Call Block */
FunctionCall:           IDENTIFIER_TOKEN LRB RRB
                        | IDENTIFIER_TOKEN LRB Expression RRB
                        | INPUT LRB RRB
                        ;

/* Array Usage */
Array:                  IDENTIFIER_TOKEN LSB Expression RSB 
                        | IDENTIFIER_TOKEN LSB Expression RSB SPL IDENTIFIER_TOKEN LSB Expression RSB ;

/* Function block */
Function:               Type IDENTIFIER_TOKEN LRB ArgListOpt RRB CompoundStmt ;

ArgListOpt:             ArgList |  ;

ArgList:                ArgList ',' Arg | Arg;

Arg:	                Type IDENTIFIER_TOKEN;

CompoundStmt:	        LCB StmtList RCB ;

StmtList:	            StmtList Stmt |	;

Stmt:                   WhileStmt
                        | Declaration
                        | ForStmt
                        | IfStmt
                        | PrintFunc
                        | SCOL
                        ;

/* Type Identifier block */
Type:	                VAR | VOID ;

/* Loop Blocks */ 
WhileStmt:              WHILE LRB Expr RRB CompoundStmt;

/* For Block */
ForStmt:                FOR LRB Expr SCOL Expr SCOL Expr RRB Stmt 
                        | FOR LRB Expr SCOL Expr SCOL Expr RRB CompoundStmt 
                        | FOR LRB Expr RRB Stmt 
                        | FOR LRB Expr RRB CompoundStmt ;

/* IfStmt Block */
IfStmt:                 IF LRB Expr RRB CompoundStmt 
                        | IF LRB Expr RRB CompoundStmt ElseStmt
                        | IF LRB Expr RRB CompoundStmt ElifStmt ;

/* ElseStmt Block */
ElseStmt:               ELSE CompoundStmt ;

/* ElifStmt Block */
ElifStmt:               ELIF LRB Expr RRB CompoundStmt ElifStmt 
                        | ELIF LRB Expr RRB CompoundStmt
                        | ELIF LRB Expr RRB CompoundStmt ElseStmt ;

/* Print Function */
PrintFunc:  
                        FLASH LRB STRING_TOKEN RRB SCOL
                        | FLASH LRB IDENTIFIER_TOKEN RRB SCOL
                        | FLASH LRB  RRB SCOL  ;

/*Expression Block*/
Expr:	
                        | Expr LE_OP Expr 
                        | Expr GE_OP Expr
                        | Expr NOTEQUAL_OP Expr
                        | Expr EQUAL_OP Expr
                        | Expr GT_OP Expr
                        | Expr LT_OP Expr
                        | Expression
                        | Array
                        ;

%%

int main(int argc, char *argv[])
{


    symboltable =  create_table() ;

    yyin = fopen(argv[1], "r");

    if(!yyparse())
    {
        printf("\nParsing completed Successfully\n");
    }
    else
    {
            printf("\nParsing failed\n");
    }


    printf("\n\t\t   SYMBOL TABLE\n");
    display(symboltable);


    fclose(yyin);
    return 0;
}

int yyerror(char *errmsg)
{
    printf("Error -> %s",errmsg);
}
