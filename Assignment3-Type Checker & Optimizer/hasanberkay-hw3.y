%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hasanberkay-hw3.h"

void yyerror (const char *s) 
{}

void printConstExprNodePtr2(exprNode*);
exprNode* createIntNode(int);
exprNode* createDoubleNode(double);
exprNode* createStringNode(char*);
void printLiteralExpr(exprNode*);
%}

%union {
    int intValue;
    int lineCount;
    double realValue;
    char* stringValue;
    exprNode* node;
    OpNode opNode;
    OpNode *opNodePtr;
}

%token <intValue> tNUM
%token <realValue> tREAL
%token <stringValue> tSTRING

%token <opNode> tADD tSUB tMUL tDIV;

%type <node> constExpr constOperation 

%token tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC

%start prog

%%
prog:		'[' stmtlst ']'
;

stmtlst:	stmtlst stmt |
;

stmt:		setStmt | if | print | unaryOperation | expr | returnStmt
;

getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
		| '[' tGET ',' tIDENT ',' '[' ']' ']'
		| '[' tGET ',' tIDENT ']'
;

setStmt:	'[' tSET ',' tIDENT ',' expr ']'
;

if:		'[' tIF ',' condition ',' '[' stmtlst ']' ']'
		| '[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;

print:		'[' tPRINT ',' expr ']'
;

constOperation: '[' tADD ',' constExpr ',' constExpr ']' {
                if ($4->type == intType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = intType;
                    $$->intValue = $4->intValue + $6->intValue;
                    $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue + $6->realValue;
                    $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue + $6->intValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == intType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->intValue + $6->realValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == stringType && $6->type == stringType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = stringType;
                    $$->stringValue = strcat($4->stringValue,$6->stringValue);
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else{
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = errorType;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }
            }

		| '[' tSUB ',' constExpr ',' constExpr ']' {
                if ($4->type == intType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = intType;
                    $$->intValue = $4->intValue - $6->intValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue - $6->realValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue - $6->intValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == intType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->intValue - $6->realValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else{
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = errorType;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }
        }


		| '[' tMUL ',' constExpr ',' constExpr ']' {
                if ($4->type == intType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = intType;
                    $$->intValue = $4->intValue * $6->intValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue * $6->realValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue * $6->intValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == intType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->intValue * $6->realValue;
                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == intType && $6->type == stringType) {
                    char* resultString = (char*)malloc(strlen($6->stringValue) * $4->intValue + 1);
                    strcpy(resultString, "");

                    int i;
                    for (i = 0; i < $4->intValue; i++) {
                        strcat(resultString, $6->stringValue);
                    }

                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = stringType;
                    $$->stringValue = resultString;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else{
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = errorType;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }
        }

		| '[' tDIV ',' constExpr ',' constExpr ']' {

                if ($4->type == intType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = intType;
                    $$->intValue = $4->intValue / $6->intValue;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue / $6->realValue;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == doubleType && $6->type == intType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->realValue / $6->intValue;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else if($4->type == intType && $6->type == doubleType) {
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = doubleType;
                    $$->realValue = $4->intValue / $6->realValue;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }

                else{
                    $$ = (exprNode*)malloc(sizeof(exprNode));
                    $$->type = errorType;

                                        $$->left = $4;
                    $$->right = $6;
                    $$->lineNum = $2.lineNum;
                }
        }
;	

unaryOperation: '[' tINC ',' tIDENT ']'
		| '[' tDEC ',' tIDENT ']'
;

nonConstExpr:   getExpr 
            | function 
            | condition
            | nonConstOperation
;

nonConstOperation: '[' tADD ',' nonConstExpr ',' nonConstExpr ']' 
        | '[' tADD ',' constExpr ',' nonConstExpr ']' {printConstExprNodePtr2($4);}
        | '[' tADD ',' nonConstExpr ',' constExpr ']' {printConstExprNodePtr2($6);}
		| '[' tSUB ',' nonConstExpr ',' nonConstExpr ']'
		| '[' tSUB ',' constExpr ',' nonConstExpr ']'{printConstExprNodePtr2($4);}
		| '[' tSUB ',' nonConstExpr ',' constExpr ']'{printConstExprNodePtr2($6);}
		| '[' tMUL ',' nonConstExpr ',' nonConstExpr ']' 
		| '[' tMUL ',' constExpr ',' nonConstExpr ']' {printConstExprNodePtr2($4);}
		| '[' tMUL ',' nonConstExpr ',' constExpr ']' {printConstExprNodePtr2($6);}
		| '[' tDIV ',' nonConstExpr ',' nonConstExpr ']'
		| '[' tDIV ',' constExpr ',' nonConstExpr ']'{printConstExprNodePtr2($4);}
		| '[' tDIV ',' nonConstExpr ',' constExpr ']'{printConstExprNodePtr2($6);}
;

constExpr:  tNUM {$$ = createIntNode($1);}
            |   tSTRING {$$ = createStringNode($1);}
            |   tREAL {$$ = createDoubleNode($1);}
            |   constOperation { $$ = $1;}
;

expr:       constExpr {printConstExprNodePtr2($1);} 
            | nonConstExpr         
;

function:	 '[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
		| '[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;

condition:	'[' tEQUALITY ',' expr ',' expr ']'
		| '[' tGT ',' expr ',' expr ']'
		| '[' tLT ',' expr ',' expr ']'
		| '[' tGEQ ',' expr ',' expr ']'
		| '[' tLEQ ',' expr ',' expr ']'
;

returnStmt:	'[' tRETURN ',' expr ']'
		| '[' tRETURN ']'
;

parametersList: parametersList ',' tIDENT | tIDENT
;

exprList:	exprList ',' expr | expr
;

%%

void printConstExprNodePtr(exprNode* root){
    if (root == NULL) {
        return;
    }

    if ( (root->left->type != errorType) && (root->right->type != errorType) ){
        printf("Type mismatch on %d\n", root->lineNum); 
        printConstExprNodePtr2(root->left); 
        printConstExprNodePtr2(root->right); 
	}
    else if ( (root->left->type == errorType) && (root->right->type != errorType) ){
        printConstExprNodePtr(root->left);
        printConstExprNodePtr2(root->right);
    } 
    else if ( (root->right->type == errorType) && (root->left->type != errorType) ){
        printConstExprNodePtr(root->right);
        printConstExprNodePtr2(root->left);
    } 
    else {
        printConstExprNodePtr(root->left);
        printConstExprNodePtr(root->right);
    }

}
    

void printConstExprNodePtr2(exprNode* constExprNodePtr){
    if (constExprNodePtr->left == NULL || constExprNodePtr->right == NULL)
    {   return; }

	if (constExprNodePtr->type == errorType){
        printConstExprNodePtr(constExprNodePtr);
		//printf("Type mismatch on %d\n", constExprNodePtr->lineNum);
	}

	else if (constExprNodePtr->type == intType || constExprNodePtr->type == doubleType || constExprNodePtr->type == stringType){
		printf("Result of expression on %d is ", constExprNodePtr->lineNum);
		switch (constExprNodePtr->type){
			case intType:
				//addExpressionToList(constExprNodePtr);
                printf("(%d)\n", constExprNodePtr->intValue);
				break;
			case doubleType:
				printf("(%.1f)\n", constExprNodePtr->realValue);
				break;
			case stringType:
				printf("(%s)\n", constExprNodePtr->stringValue);
				break;
		}
	}
}

exprNode* createIntNode(int val) {
    exprNode* newNode = malloc( sizeof(exprNode) );
    newNode->intValue = val;
    newNode->type = intType;

    return newNode;
}

exprNode* createDoubleNode(double val) {
    exprNode* newNode = malloc( sizeof(exprNode) );
    newNode->realValue = val;
    newNode->type = doubleType;

    return newNode;
}

exprNode* createStringNode(char* val) {
    exprNode* newNode = malloc(sizeof(exprNode));
    newNode->stringValue = malloc(strlen(val) + 1);
    strcpy(newNode->stringValue, val);
    newNode->type = stringType;

    return newNode;
}

int main ()
{
    if (yyparse()) {
        printf("ERROR\n");
        return 1;
    }
    else {
        //printf("OK\n");
        return 0;
    }
}

