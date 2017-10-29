#include <stdio.h>
#include "../include/AST.h"

extern FILE *yyin;
extern int yylex(void);
extern void yyrestart(FILE*);
extern int yyparse(void);
extern struct ASTNode *ASTroot;

int main(int argc, char **argv)
{
    if (argc <= 1)
        return 1;
    FILE *f = fopen(argv[1], "r");
    if (!f)
    {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yyparse();

    ASTwalk(ASTroot, 0);
    freeAST(ASTroot);
    ASTroot = NULL;

    return 0;
}
