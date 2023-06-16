%{
    #include <stdio.h>       
    void yyerror (const char* msg) { return; }
%}

%token tSTRING;
%token tGET;
%token tSET;
%token tFUNCTION;
%token tPRINT;
%token tIF;
%token tRETURN;
%token tADD;
%token tSUB;
%token tMUL;
%token tDIV;
%token tINC;
%token tGT;
%token tEQUALITY;
%token tDEC;
%token tLT;
%token tLEQ;
%token tGEQ;
%token tIDENT;
%token tNUM;

%%

start:      '[' stmntSeq ']' 
        |   '[' /* EMPTY */ ']' 
;

stmntSeq:   stmnt
        |   stmnt stmntSeq
;

stmnt:      stmntSet
        |   stmntIf
        |   stmntPrint
        |   stmntInc
        |   stmntDec
        |   stmntRet
        |   express
;

stmntSet:   '[' tSET ',' tIDENT ',' express ']'
;

stmntIf:    matched | unmatched
;

matched:    '[' tIF ',' condition ',' '[' stmntSeq ']' '[' stmntSeq ']' ']'
        |   '[' tIF ',' condition ',' '[' ']' '[' ']' ']'
        |   '[' tIF ',' condition ',' '[' ']' '[' stmntSeq ']' ']'
        |   '[' tIF ',' condition ',' '[' stmntSeq ']' '['  ']' ']'
;

unmatched:  '[' tIF ',' condition ',' '[' stmntSeq ']' ']'
        |   '[' tIF ',' condition ',' '['  ']' ']'
;

stmntPrint: '[' tPRINT ',' express ']'
;

stmntInc:   '[' tINC ',' tIDENT ']'
;

stmntDec:   '[' tDEC ',' tIDENT ']'
;

condition:  '[' tLEQ ',' express ',' express ']'
        |   '[' tGEQ ',' express ',' express ']'
        |   '[' tEQUALITY ',' express ',' express ']'
        |   '[' tGT ',' express ',' express ']'
        |   '[' tLT ',' express ',' express ']'
;

express:    tNUM
        |   tSTRING
        |   expressGet
        |   funcDeclare
        |   operatorApp
        |   condition
;

expressGet:     '[' tGET ',' tIDENT ']' 
        |       '[' tGET ',' tIDENT ',' '[' ']' ']' 
        |       '[' tGET ',' tIDENT ',' '[' expressList ']' ']'     
;

expressList:    express
        |       express ',' expressList
;  

funcDeclare:    '[' tFUNCTION ',' '[' paramList ']' ',' '[' stmntSeq ']' ']'    
        |       '[' tFUNCTION ',' '[' paramList ']' ',' '[' /* EMPTY */ ']' ']' 
        |       '[' tFUNCTION ',' '[' /* EMPTY */ ']' ',' '[' stmntSeq ']' ']'
        |       '[' tFUNCTION ',' '[' /* EMPTY */ ']' ',' '[' /* EMPTY */ ']' ']'   
;

paramList:      tIDENT
        |       tIDENT ',' paramList
;

operatorApp:    '[' tADD ',' express ',' express ']'
            |   '[' tSUB ',' express ',' express ']'
            |   '[' tMUL ',' express ',' express ']'
            |   '[' tDIV ',' express ',' express ']'
;

stmntRet:   '[' tRETURN ']'
        |   '[' tRETURN ',' express ']'
;

%%

int main (){
    if (yyparse()){
        printf("ERROR\n");
        return 1;
    }

    else{
        printf("OK\n");
        return 0;
    }
}