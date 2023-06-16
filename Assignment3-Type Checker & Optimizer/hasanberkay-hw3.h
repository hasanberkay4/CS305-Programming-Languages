#ifndef __HASANBERKAYHW3_H
#define __HASANBERKAYHW3_H

typedef enum nodeType {
    intType, 
    doubleType, 
    stringType,
    errorType
} nodeType;

typedef enum { ADD, SUB, MUL, DIV } OpType;

typedef struct OpNode {
    OpType opType;
    int lineNum;
} OpNode;

extern int lineCount;

typedef struct exprNode {
    nodeType type;
    int intValue; 
    double realValue;
    struct exprNode* left;
    struct exprNode* right;
    int lineNum;
    char* stringValue; 
} exprNode;

#endif