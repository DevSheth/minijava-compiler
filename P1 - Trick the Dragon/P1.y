%{
	#include<stdio.h>
    #include<stdlib.h>
	#include<string.h>

    int yyerror(char* h);
    int yylex(void);
	
    struct Node {
        char *val;
        struct Node *next;
    };

    struct List {
        struct Node *HEAD;
        struct Node *TAIL;
    };

    struct List *MacroStmnts[100][3];
    struct List *MacroExps[100][3];
    int count1 = 0;
    int count2 = 0;

    struct List* Append(struct List *a, struct List *b){
        a->TAIL->next = b->HEAD;
        a->TAIL = b->TAIL;
        return a;
    }

    void PrintString(struct List *a){
        struct Node *tmp;
        tmp = a->HEAD;
        while(tmp != NULL){
            printf("%s", tmp->val);
            tmp = tmp->next;
        }
    }

    int Compare(struct Node *a, struct Node *b){
        if(a == NULL || b == NULL) return 1;
        return strcmp(a->val, b->val);
    }

    void RecordMacroStmnt(struct Node *id, struct List *IDs, struct List *stmnts){
        struct List* tmp1 = (struct List*) malloc(sizeof(struct List));
        tmp1->HEAD = id;
        tmp1->TAIL = id;
        int i;
        for(i=0; i<count1; i++){
            if(Compare(id, MacroStmnts[i][0]->HEAD) == 0) break;
        }
        if(i == count1) count1++; 
        MacroStmnts[i][0] = tmp1;
        struct List* tmp2 = (struct List*) malloc(sizeof(struct List));
        struct Node* temp1;
        struct Node* temp2;
        if(strcmp(IDs->HEAD->val, " ") == 0){
            tmp2->HEAD = NULL;
            tmp2->TAIL = NULL;
        }
        else{
            tmp2->HEAD = IDs->HEAD;
            temp2 = tmp2->HEAD;
            temp1 = IDs->HEAD->next->next;
            while(temp1 != NULL){
                temp2->next = temp1->next;
                temp1 = temp1->next->next;
                temp2 = temp2->next;
            }
            temp2->next = NULL;
            tmp2->TAIL = temp2;
        }
        MacroStmnts[i][1] = tmp2;
        MacroStmnts[i][2] = stmnts;
    }

    void RecordMacroExp(struct Node *id, struct List *IDs, struct List *exps){
        struct List* tmp1 = (struct List*) malloc(sizeof(struct List));
        tmp1->HEAD = id;
        tmp1->TAIL = id;
        int i;
        for(i=0; i<count2; i++){
            if(Compare(id, MacroExps[i][0]->HEAD) == 0) break;
        }
        if(i == count2) count2++;
        MacroExps[i][0] = tmp1;
        struct List* tmp2 = (struct List*) malloc(sizeof(struct List));
        struct Node* temp1;
        struct Node* temp2;
        if(strcmp(IDs->HEAD->val, " ") == 0){
            tmp2->HEAD = NULL;
            tmp2->TAIL = NULL;
        }
        else{
            tmp2->HEAD = IDs->HEAD;
            temp2 = tmp2->HEAD;
            temp1 = IDs->HEAD->next->next;
            while(temp1 != NULL){
                temp2->next = temp1->next;
                temp1 = temp1->next->next;
                temp2 = temp2->next;
            }
            temp2->next = NULL;
            tmp2->TAIL = temp2;
        }
        MacroExps[i][1] = tmp2;
        MacroExps[i][2] = exps;
    }

    struct List* Replace(struct List* M[], struct List* E[], int c2){
        struct Node *TMP;
        int c1 = 0;
        TMP = M[1]->HEAD;
        while(TMP != NULL){
            TMP = TMP->next;
            c1++;
        }
        if(c1 != c2){
            yyerror("");
            exit(0);
        }
        struct List *ANS = (struct List*) malloc(sizeof(struct List));
        ANS->HEAD = (struct Node*) malloc(sizeof(struct Node));
        ANS->HEAD->val = M[2]->HEAD->val;
        struct Node *temp1 = M[2]->HEAD;
        struct Node *temp2 = M[1]->HEAD;
        struct Node *temp3 = NULL;
        struct Node *temp4 = ANS->HEAD;
        struct Node *temp5;
        struct Node *temp6;
        int count = 0;
        while(Compare(temp1, temp2) != 0 && temp2 != NULL){
            temp2 = temp2->next;
            count++;
        }
        if(temp2 == NULL){
            temp1 = temp1->next; 
        }
        else{
            ANS->HEAD->val = E[count]->HEAD->val;
            temp5 = E[count]->HEAD->next;
            while(temp5 != NULL){
                struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                new->val = temp5->val;
                temp4->next = new;
                temp3 = temp4;
                temp4 = temp4->next;
                temp5 = temp5->next;
            }
            temp1 = temp1->next;
        }
        while(temp1 != NULL){
            count = 0;
            temp2 = M[1]->HEAD;
            struct Node *new = (struct Node*) malloc(sizeof(struct Node));
            new->val = temp1->val;
            temp4->next = new;
            temp3 = temp4;
            temp4 = temp4->next;
            while(Compare(temp1, temp2) != 0 && temp2 != NULL){
                temp2 = temp2->next;
                count++;
            }
            if(temp2 == NULL){
                temp1 = temp1->next; 
            }
            else{
                temp4->val = E[count]->HEAD->val;
                temp5 = E[count]->HEAD->next;
                while(temp5 != NULL){
                    struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                    new->val = temp5->val;
                    temp4->next = new;
                    temp3 = temp4;
                    temp4 = temp4->next;
                    temp5 = temp5->next;
                }
                temp1 = temp1->next;
            }
        }
        temp4->next = NULL;
        ANS->TAIL = temp4;
        return ANS;
    }

    struct List* ReplaceMacroStmnt(struct List* mac){
        int it1 = 0;
        while(it1 < count1){
            if(Compare(mac->HEAD, MacroStmnts[it1][0]->HEAD) != 0) it1++;
            else break;
        }
        if(it1 == count1){
            yyerror("");
            exit(0);
        } 
        else{
            struct List* EXPS[100];
            struct Node* temp1;
            struct Node* temp2;
            struct Node* temp3;
            struct Node* temp4;
            int expcount = 0;
            temp1 = mac->HEAD->next->next;
            if(strcmp(temp1->val, " ") == 0){
                struct List *tmp = (struct List*) malloc(sizeof(struct List));
                tmp->HEAD = (struct Node*) malloc(sizeof(struct Node));
                tmp->HEAD->val = MacroStmnts[it1][2]->HEAD->val;
                temp2 = tmp->HEAD;
                temp3 = MacroStmnts[it1][2]->HEAD->next;
                while(temp3 != NULL){
                    struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                    new->val = temp3->val;
                    temp2->next = new;
                    temp2 = new;
                    temp3 = temp3->next;
                }
                temp2->next = NULL;
                tmp->TAIL = temp2;
                return tmp;
            }
            else{
                EXPS[expcount] = (struct List*) malloc(sizeof(struct List));
                EXPS[expcount]->HEAD = (struct Node*) malloc(sizeof(struct Node));
                EXPS[expcount]->HEAD->val = temp1->val;
                temp2 = EXPS[expcount]->HEAD;
                temp1 = temp1->next;
                while(strcmp(temp1->val, " , ") != 0 && strcmp(temp1->val, " );\n") != 0){
                    struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                    new->val = temp1->val;
                    temp2->next = new;
                    temp4 = temp2;
                    temp2 = temp2->next;
                    temp1 = temp1->next;
                }
                temp4->next = NULL;
                EXPS[expcount]->TAIL = temp4;
                expcount++;
                temp3 = temp1;
                while(strcmp(temp3->val, " );\n") != 0){
                    temp1 = temp1->next;
                    EXPS[expcount] = (struct List*) malloc(sizeof(struct List));
                    EXPS[expcount]->HEAD = (struct Node*) malloc(sizeof(struct Node));
                    EXPS[expcount]->HEAD->val = temp1->val;
                    temp2 = EXPS[expcount]->HEAD;
                    temp1 = temp1->next;
                    while(strcmp(temp1->val, " , ") != 0 && strcmp(temp1->val, " );\n") != 0){
                        struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                        new->val = temp1->val;
                        temp2->next = new;
                        temp4 = temp2;
                        temp2 = temp2->next;
                        temp1 = temp1->next;
                    }
                    temp4->next = NULL;
                    EXPS[expcount]->TAIL = temp4;
                    expcount++;
                    temp3 = temp1;
                }
                return Replace(MacroStmnts[it1], EXPS, expcount);
            }
        }
    }

    struct List* ReplaceMacroExp(struct List* mac){
        int it2 = 0;
        while(it2 < count2){
            if(Compare(mac->HEAD, MacroExps[it2][0]->HEAD) != 0) it2++;
            else break;
        }
        if(it2 == count2){
            yyerror("");
            exit(0);
        } 
        else{
            struct List* EXPS[100];
            struct Node* temp1;
            struct Node* temp2;
            struct Node* temp3;
            struct Node* temp4;
            int expcount = 0;
            temp1 = mac->HEAD->next->next;
            if(strcmp(temp1->val, " ") == 0){
                struct List *tmp = (struct List*) malloc(sizeof(struct List));
                tmp->HEAD = (struct Node*) malloc(sizeof(struct Node));
                tmp->HEAD->val = MacroExps[it2][2]->HEAD->val;
                temp2 = tmp->HEAD;
                temp3 = MacroExps[it2][2]->HEAD->next;
                while(temp3 != NULL){
                    struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                    new->val = temp3->val;
                    temp2->next = new;
                    temp2 = new;
                    temp3 = temp3->next;
                }
                temp2->next = NULL;
                tmp->TAIL = temp2;
                return tmp;
            }
            else{
                EXPS[expcount] = (struct List*) malloc(sizeof(struct List));
                EXPS[expcount]->HEAD = (struct Node*) malloc(sizeof(struct Node));
                EXPS[expcount]->HEAD->val = temp1->val;
                temp2 = EXPS[expcount]->HEAD;
                temp1 = temp1->next;
                while(strcmp(temp1->val, " , ") != 0 && strcmp(temp1->val, " ) ") != 0){
                    struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                    new->val = temp1->val;
                    temp2->next = new;
                    temp4 = temp2;
                    temp2 = temp2->next;
                    temp1 = temp1->next;
                }
                temp4->next = NULL;
                EXPS[expcount]->TAIL = temp4;
                expcount++;
                temp3 = temp1;
                while(strcmp(temp3->val, " ) ") != 0){
                    temp1 = temp1->next;
                    EXPS[expcount] = (struct List*) malloc(sizeof(struct List));
                    EXPS[expcount]->HEAD = (struct Node*) malloc(sizeof(struct Node));
                    EXPS[expcount]->HEAD->val = temp1->val;
                    temp2 = EXPS[expcount]->HEAD;
                    temp1 = temp1->next;
                    while(strcmp(temp1->val, " , ") != 0 && strcmp(temp1->val, " ) ") != 0){
                        struct Node *new = (struct Node*) malloc(sizeof(struct Node));
                        new->val = temp1->val;
                        temp2->next = new;
                        temp4 = temp2;
                        temp2 = temp2->next;
                        temp1 = temp1->next;
                    }
                    temp4->next = NULL;
                    EXPS[expcount]->TAIL = temp4;
                    expcount++;
                    temp3 = temp1;
                }
                return Replace(MacroExps[it2], EXPS, expcount);
            }
        }
    } 
%}

%union
{
    char* integer;
    char* identifier;
    struct List* list;
}

%start Goal ;
%type <list> Goal MacroDefinition1 MainClass TypeDeclaration1 MacroDefinition MacroDefExpression MacroDefStatement TypeDeclaration
%type <list> TypeIdentifier TypeIdentifier1 TypeIdentifierc
%type <list> MethodDeclaration Type Statement1 Statement PrimaryExpression
%type <list> Expression Expression1 Expressionc
%type <list> Identifier1 Identifierc
%type <integer> Integer
%type <identifier> Identifier
%token Class Public Static Void Main STring Print Extends Return Int BOOlean IF ELSE WHILE Length True False This New Define
%token Ocurlbrac Ccurlbrac Osqbrac Csqbrac Obrac Cbrac And Or Notequal Lessthanequal Dot Comma Exclaim 
%token Plus Minus Mul Div End Equals Integer Identifier 

%%
Goal : MacroDefinition1 MainClass TypeDeclaration1 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $1 = Append($1, $2);
    $$ = Append($1, $3);
    PrintString($$);
}
;

MainClass : Class Identifier Ocurlbrac Public Static Void Main Obrac STring Osqbrac Csqbrac Identifier Cbrac Ocurlbrac Print Obrac Expression Cbrac End Ccurlbrac Ccurlbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "class ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $2;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(50);
    C->val = " { \npublic static void main ( String [] ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(20);
    D->val = $12;
    struct Node *E = (struct Node*) malloc(sizeof(struct Node));
    E->val = (char*) malloc(30);
    E->val = " ) {\nSystem.out.println( ";
    struct Node *F = (struct Node*) malloc(sizeof(struct Node));
    F->val = (char*) malloc(20);
    F->val = " );\n}\n}\n";
    A->next = B;
    B->next = C;
    C->next = D;
    D->next = E;
    E->next = $17->HEAD;
    $17->TAIL->next = F;
    F->next = NULL;
    $$->HEAD = A;
    $$->TAIL = F;
}
;

MacroDefinition1 : MacroDefinition1 MacroDefinition 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = Append($1, $2);
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

MacroDefinition : MacroDefExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = $1;
}
    |   MacroDefStatement
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = $1;
}
;

TypeDeclaration1 : TypeDeclaration1 TypeDeclaration
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = Append($1, $2);
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

TypeDeclaration : Class Identifier Ocurlbrac TypeIdentifier MethodDeclaration Ccurlbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "class ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $2;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " {\n";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(10);
    D->val = " }\n";
    A->next = B;
    B->next = C;
    C->next = $4->HEAD;
    $4->TAIL->next = $5->HEAD;
    $5->TAIL->next = D;
    D->next = NULL;
    $$->HEAD = A;
    $$->TAIL = D; 
}
    | Class Identifier Extends Identifier Ocurlbrac TypeIdentifier MethodDeclaration Ccurlbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "class ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $2;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(20);
    C->val = " extends ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(100);
    D->val = $4;
    struct Node *E = (struct Node*) malloc(sizeof(struct Node));
    E->val = (char*) malloc(10);
    E->val = " {\n";
    struct Node *F = (struct Node*) malloc(sizeof(struct Node));
    F->val = (char*) malloc(10);
    F->val = " }\n";
    A->next = B;
    B->next = C;
    C->next = D;
    D->next = E;
    E->next = $6->HEAD;
    $6->TAIL->next = $7->HEAD;
    $7->TAIL->next = F;
    F->next = NULL;
    $$->HEAD = A;
    $$->TAIL = F; 
}
;

TypeIdentifier : TypeIdentifier Type Identifier End 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $3;
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " ;\n";
    $1 = Append($1, $2);
    $1->TAIL->next = A;
    A->next = B;
    B->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = B;
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

MethodDeclaration : MethodDeclaration Public Type Identifier Obrac TypeIdentifier1 Cbrac Ocurlbrac TypeIdentifier Statement1 Return Expression End Ccurlbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " public ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $4;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " ( ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(10);
    D->val = " ) {\n";
    struct Node *E = (struct Node*) malloc(sizeof(struct Node));
    E->val = (char*) malloc(10);
    E->val = "\n return ";
    struct Node *F = (struct Node*) malloc(sizeof(struct Node));
    F->val = (char*) malloc(10);
    F->val = ";\n}\n";
    
    $1->TAIL->next = A;
    A->next = $3->HEAD;    
    $3->TAIL->next = B;
    B->next = C;
    C->next = $6->HEAD;
    $6->TAIL->next = D;
    $9 = Append($9, $10);
    D->next = $9->HEAD;
    $9->TAIL->next = E;
    E->next = $12->HEAD;
    $12->TAIL->next = F;
    F->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = F;
}
    |
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

TypeIdentifier1 : Type Identifier TypeIdentifierc
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $2;
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

TypeIdentifierc : TypeIdentifierc Comma Type Identifier
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " , ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $4;
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = B;
    B->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = B;
}
    |
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

Type : Int Osqbrac Csqbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "int [] ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | BOOlean
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "boolean ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | Int
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "int ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | Identifier
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " ";
    A->next = B;
    B->next = NULL;
    $$->HEAD = A;
    $$->TAIL = B;
}
;

Statement1 : Statement Statement1 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = Append($1, $2);
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

Statement : Ocurlbrac Statement1 Ccurlbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " {\n";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = "\n}\n";
    A->next = $2->HEAD;
    $2->TAIL->next = B;
    B->next = NULL;
    $$->HEAD = A;
    $$->TAIL = B;
}
    | Print Obrac Expression Cbrac End
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(30);
    A->val = "System.out.println( ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " );\n";
    A->next = $3->HEAD;
    $3->TAIL->next = B;
    B->next = NULL;
    $$->HEAD = A;
    $$->TAIL = B;
}
    | Identifier Equals Expression End
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " = ";
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = ";\n";
    A->next = B;
    B->next = $3->HEAD;
    $3->TAIL->next = C;
    C->next = NULL;
    $$->HEAD = A;
    $$->TAIL = C;
}
    | Identifier Osqbrac Expression Csqbrac Equals Expression End
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = "[";
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = "] = ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(10);
    D->val = ";\n";
    A->next = B;
    B->next = $3->HEAD;
    $3->TAIL->next = C;
    C->next = $6->HEAD;
    $6->TAIL->next = D;
    D->next = NULL;
    $$->HEAD = A;
    $$->TAIL = D;
}
    | IF Obrac Expression Cbrac Statement
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(30);
    A->val = "if ( ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " )\n";
    A->next = $3->HEAD;
    $3->TAIL->next = B;
    B->next = $5->HEAD;
    $5->TAIL->next = NULL;
    $$->HEAD = A;
    $$->TAIL = $5->TAIL;
}
    | IF Obrac Expression Cbrac Statement ELSE Statement
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(30);
    A->val = "if ( ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " )\n";
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " else\n ";
    A->next = $3->HEAD;
    $3->TAIL->next = B;
    B->next = $5->HEAD;
    $5->TAIL->next = C;
    C->next = $7->HEAD;
    $7->TAIL->next = NULL;
    $$->HEAD = A;
    $$->TAIL = $7->TAIL;
}
    | WHILE Obrac Expression Cbrac Statement
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(30);
    A->val = "while ( ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " )\n";
    A->next = $3->HEAD;
    $3->TAIL->next = B;
    B->next = $5->HEAD;
    $5->TAIL->next = NULL;
    $$->HEAD = A;
    $$->TAIL = $5->TAIL;
}
    | Identifier Obrac Expression1 Cbrac End
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " ( ";
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " );\n";
    A->next = B;
    B->next = $3->HEAD;
    $3->TAIL->next = C;
    C->next = NULL;
    $$->HEAD = A;
    $$->TAIL = C;
    $$ = ReplaceMacroStmnt($$);
}
;

Expression1 : Expression Expressionc
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = Append($1, $2);
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

Expressionc : Expressionc Comma Expression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " , ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

Expression : PrimaryExpression And PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " && ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Or PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " || ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Notequal PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " != ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Lessthanequal PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " <= ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Plus PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " + ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Minus PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " - ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Mul PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " * ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Div PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " / ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = $3->TAIL;
}
    | PrimaryExpression Osqbrac PrimaryExpression Csqbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " [ ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " ] ";
    $1->TAIL->next = A;
    A->next = $3->HEAD;
    $3->TAIL->next = B;
    B->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = B;
}
    | PrimaryExpression Dot Length
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(20);
    A->val = " . length";
    $1->TAIL->next = A;
    A->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = A;
}
    | PrimaryExpression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    $$ = $1;
}
    | PrimaryExpression Dot Identifier Obrac Expression1 Cbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " . ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $3;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " ( ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(10);
    D->val = " ) ";
    $1->TAIL->next = A;
    A->next = B;
    B->next = C;
    C->next = $5->HEAD;
    $5->TAIL->next = D;
    D->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = D;
}
    | Identifier Obrac Expression1 Cbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " ( ";
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " ) ";
    A->next = B;
    B->next = $3->HEAD;
    $3->TAIL->next = C;
    C->next = NULL;
    $$->HEAD = A;
    $$->TAIL = C;
    $$ = ReplaceMacroExp($$);
    B->next = $$->HEAD;
    $$->TAIL->next = C;
    C->next = NULL;
    $$->HEAD = B;
    $$->TAIL = C;
}
;

PrimaryExpression : Integer
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | True
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "true ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | False
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "false ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | Identifier
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | This
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "this ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
    | New Int Osqbrac Expression Csqbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "new int ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " [ ";
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = " ] ";
    A->next = B;
    B->next = $4->HEAD;
    $4->TAIL->next = C;
    C->next = NULL;
    $$->HEAD = A;
    $$->TAIL = C;
}
    | New Identifier Obrac Cbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "new ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $2;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(10);
    C->val = "()";
    A->next = B;
    B->next = C;
    C->next = NULL;
    $$->HEAD = A;
    $$->TAIL = C;
}
    | Exclaim Expression
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "!";
    A->next = $2->HEAD;
    $2->TAIL->next = NULL;
    $$->HEAD = A;
    $$->TAIL = $2->TAIL;
}
    | Obrac Expression Cbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "( ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(10);
    B->val = " )";
    A->next = $2->HEAD;
    $2->TAIL->next = B;
    B->next = NULL;
    $$->HEAD = A;
    $$->TAIL = B;
}
;

MacroDefStatement : Define Identifier Obrac Identifier1 Cbrac Ocurlbrac Statement1 Ccurlbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "#define ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $2;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(20);
    C->val = " ( ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(10);
    D->val = " ) { ";
    struct Node *E = (struct Node*) malloc(sizeof(struct Node));
    E->val = (char*) malloc(10);
    E->val = " }\n";
    RecordMacroStmnt(B, $4, $7);
    struct Node *F = (struct Node*) malloc(sizeof(struct Node));
    F->val = (char*) malloc(10);
    F->val = "\n";
    F->next = NULL;
    $$->HEAD = F;
    $$->TAIL = F;
}
;

MacroDefExpression : Define Identifier Obrac Identifier1 Cbrac Obrac Expression Cbrac
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = "#define ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $2;
    struct Node *C = (struct Node*) malloc(sizeof(struct Node));
    C->val = (char*) malloc(20);
    C->val = " ( ";
    struct Node *D = (struct Node*) malloc(sizeof(struct Node));
    D->val = (char*) malloc(10);
    D->val = " ) ( ";
    struct Node *E = (struct Node*) malloc(sizeof(struct Node));
    E->val = (char*) malloc(10);
    E->val = " )\n";
    RecordMacroExp(B, $4, $7);
    struct Node *F = (struct Node*) malloc(sizeof(struct Node));
    F->val = (char*) malloc(10);
    F->val = "\n";
    F->next = NULL;
    $$->HEAD = F;
    $$->TAIL = F;
}
;

Identifier1 : Identifier Identifierc
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(100);
    A->val = $1;
    A->next = $2->HEAD;
    $$->HEAD = A;
    $$->TAIL = $2->TAIL;
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;

Identifierc : Identifierc Comma Identifier
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " , ";
    struct Node *B = (struct Node*) malloc(sizeof(struct Node));
    B->val = (char*) malloc(100);
    B->val = $3;
    $1->TAIL->next = A;
    A->next = B;
    B->next = NULL;
    $$->HEAD = $1->HEAD;
    $$->TAIL = B;
}
    | 
{
    $$ = (struct List*) malloc(sizeof(struct List));
    struct Node *A = (struct Node*) malloc(sizeof(struct Node));
    A->val = (char*) malloc(10);
    A->val = " ";
    A->next = NULL;
    $$->HEAD = A;
    $$->TAIL = A;
}
;
%%

int yyerror(char *s)
{
	printf("// Failed to parse macrojava code.\n");
	return 0;  
}
int main ()
{
	yyparse();
	return 0;
}