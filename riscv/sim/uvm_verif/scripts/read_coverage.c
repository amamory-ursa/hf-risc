/******************************************************************************
 *  UCDB API User Guide Example
 *
 *  Copyright 2018 Mentor Graphics Corporation
 *
 *  All Rights Reserved.
 *
 *  THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 *  PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 *  LICENSE TERMS.
 *
 *  Usage: <program> ucdbfile
 *
 *  UCDB API User Guide Example.
 *
 *  Read coveritem counts in a UCDB.
 *
 *****************************************************************************/
#include <ucdb.h>
#include <stdio.h>
#include <stdlib.h>

int qtd_ = 0;
int val[5000];
char* text[5000];

/*
 *  This function prints the coverage count or coverage vector to stdout.
 */
void
print_coverage_count(ucdbCoverDataT* coverdata)
{
    if (coverdata->flags & UCDB_IS_32BIT) {
        /* 32-bit count: */
        //printf("%d", coverdata->data.int32);
    } else if (coverdata->flags & UCDB_IS_64BIT) {
        /* 64-bit count: */
#if defined (_WIN64)
        printf("%I64d", (long long)coverdata->data.int64);
#else
        printf("%lld", (long long)coverdata->data.int64);
#endif
    } else if (coverdata->flags & UCDB_IS_VECTOR) {
        /* bit vector coveritem: */
        int bytelen = coverdata->bitlen/8 + (coverdata->bitlen%8)?1:0;
        int i;
        for ( i=0; i<bytelen; i++ ) {
            if (i) printf(" ");
            printf("%02x",coverdata->data.bytevector[i]);
        }
    }
}

/* Structure type for the callback private data */
struct dustate {
    int underneath;
    int subscope_counter;
};

/* Callback to report coveritem count */
ucdbCBReturnT
callback(
    void*           userdata,
    ucdbCBDataT*    cbdata)
{
    ucdbScopeT scope = (ucdbScopeT)(cbdata->obj);
    ucdbT db = cbdata->db;
    char* name;
    ucdbCoverDataT coverdata;
    ucdbSourceInfoT sourceinfo;
    struct dustate* du = (struct dustate*)userdata;

    switch (cbdata->reason) {
    /*
     *  The DU/SCOPE/ENDSCOPE logic distinguishes those objects which occur
     *  underneath a design unit.  Because of the INST_ONCE optimization, it is
     *  otherwise impossible to distinguish those objects by name.
     */
    case UCDB_REASON_DU:
        du->underneath = 1; du->subscope_counter = 0; break;
    case UCDB_REASON_SCOPE:
        if (du->underneath) {
            du->subscope_counter++;
        }
        break;
    case UCDB_REASON_ENDSCOPE:
        if (du->underneath) {
            if (du->subscope_counter)
                du->subscope_counter--;
            else
                du->underneath = 0;
        }
        break;
    case UCDB_REASON_CVBIN:
        scope = (ucdbScopeT)(cbdata->obj);
        /* Get coveritem data from scope and coverindex passed in: */
        ucdb_GetCoverData(db,scope,cbdata->coverindex,
                          &name,&coverdata,&sourceinfo);
        if (name!=NULL && name[0]!='\0') {
            /* Coveritem has a name, use it: */
            val[qtd_]= coverdata.data.int32;
            text[qtd_]=malloc( 100*sizeof(char));
            //text[qtd_]=ucdb_GetScopeHierName(db,scope);
            //strcpy(text[qtd_], ucdb_GetScopeHierName(db,scope));
            strcpy(text[qtd_], name);

            qtd_++;
            /*printf("%s%c%s: ",ucdb_GetScopeHierName(db,scope),
                   ucdb_GetPathSeparator(db),name);//*/
        } else {
            /* Coveritem has no name, use [file:line] instead: */
            /*printf("%s [%s:%d]: ",ucdb_GetScopeHierName(db,scope),
                   ucdb_GetFileName(db,&sourceinfo.filehandle),
                   sourceinfo.line);*/
        }
        //print_coverage_count(&coverdata);
        /* This is sometimes needed to disambiguate DU roll-up data: */
        if (du->underneath) {
           // printf(" (FROM DU)");
        }  
        //printf("\n");
        break;
    default: break;
    }
    return UCDB_SCAN_CONTINUE;
}

void
example_code(const char* ucdbfile)
{
    struct dustate du;
    ucdbT db = ucdb_Open(ucdbfile);
    if (db==NULL)
        return;
    ucdb_CallBack(db,NULL,callback,&du);
    ucdb_Close(db);
}

void
error_handler(void *data,
              ucdbErrorT *errorInfo)
{
    fprintf(stderr, "UCDB Error: %s\n", errorInfo->msgstr);
    if (errorInfo->severity == UCDB_MSG_ERROR)
        exit(1);
}

int
mymain(int argc, char* argv[])
{
    if (argc<2) {
        printf("Usage:   %s <ucdb file name>\n",argv[0]);
        printf("Purpose: Read coveritem counts in a UCDB.\n");
        return 1;
    }
    ucdb_RegisterErrorHandler(error_handler, NULL);
    example_code(argv[1]);
    return 0;
}

int
mymain2(int argc)
{
    if (argc<2) {
        
        printf("Purpose: Read coveritem counts in a UCDB. argc: %d\n",argc);
        return 1;
    }
    ucdb_RegisterErrorHandler(error_handler, NULL);
    
    return 0;
}

int mymain3(char* argv, int* qtd, int* valores, char** textos)
{

        printf("Usage:   %s <ucdb file name>\n",argv);
        printf("Purpose: Read coveritem counts in a UCDB.\n");
        
    ucdb_RegisterErrorHandler(error_handler, NULL);
    
    struct dustate du;
    ucdbT db = ucdb_Open(argv);
    if (db==NULL)
        return;
    ucdb_CallBack(db,NULL,callback,&du);
    ucdb_Close(db);
    *qtd = qtd_;
    printf("\n ----------------- qtd: %d",qtd_);

    for (int i = 0; i < qtd_; i++)
    {
        const char *mystr = "there";
        //printf("\n %d: %s",i, text[i]);
        valores[i]=val[i];
        textos[i]=malloc(300*sizeof(char));
        //textos[i]=text[i];
        strcpy(textos[i], text[i]);
        //strcpy(textos[i], mystr);
        //printf("\n %d: %s",i, textos[i]);
    }
    
    
 //   *qtd = 4;
    return 0;
}