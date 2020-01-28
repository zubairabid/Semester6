/*this function displays the output in SSF format modified by chris on 25-07-07 */


#include <string.h>
#include <stdio.h>
#include "struct.h"
#include "morph_logger.h"

extern char *program_name;
extern FILE *log_file;
extern char *log_messg;

#define __FUNCTION__ "resufun_hori()"

/*The function order gives info of category-enumerator-file based on feature-enumerator-file*/
extern struct order_ssf_info order[MAX_NO_OF_CAT];
extern char fe_info[][INFOSIZE];	/* fe info */
extern int FOR_USER;		/* user friendly output */
extern int ALWAYS_DEFAULT_PARADIGM;	/* considers only guessed paradigm even we get pdgm */
extern int DEFAULT_PARADIGM;	/* considers only final paradigm */


void resufun_hori(char *root,char *pdgm,int offset,char *aux_verb,char *root1,char *cat1,char *g1,char *n1,char *p1,char *kase1,char *cm1,char *tam1)
{

/* for refering characters of word , offset,feature_value */

    int loop1, loop2, loop3, loop4, loop5;
    int len_fe_info, not_found, no_of_features;	/* length of fe , no. of features word have */
    char category[WORD_SIZE];	/*  category */
    char feature[MAX_NO_OF_CAT][WORD_SIZE],
	feature_value[MAX_NO_OF_CAT][WORD_SIZE];
	char fs_str[BiggerArray];

		
    sprintf(log_messg, "INFO:|%s|%s|%s|%s|%s|%s|%s|%s", root1, cat1, g1, n1, p1, kase1, cm1, tam1); 
	//PRINT_LOG(log_file, log_messg);
    len_fe_info = strlen(fe_info[offset - 1]);
    for (loop1 = 0; ((fe_info[offset - 1][loop1] != ' ')
		     && (fe_info[offset - 1][loop1] != '\"')
		     && (fe_info[offset - 1][loop1] != '\0')); ++loop1)
	category[loop1] = fe_info[offset - 1][loop1];

    category[loop1] = '\0';
    if (FOR_USER)		/* executes when there is user friendly output */
	printf("ROOT:");
    sprintf(root1, "%s", root);
	strcpy(fs_str,root1);
	strcat(fs_str,",");

    if (FOR_USER)
	printf("CAT:");
	sprintf(cat1, "%s", category);
	sprintf(log_messg, "INFO xxa :|%s|", category); PRINT_LOG(log_file, log_messg);
	strcat(fs_str,cat1);

    loop2 = loop1 + 1;

    loop3 = 0;
    while (loop2 < len_fe_info) {	/* executes when loop2 > length of fe info */

	for (loop1 = loop2;
	     (loop1 < len_fe_info && fe_info[offset - 1][loop1] != ' ');
	     loop1++)
	    feature[loop3][loop1 - loop2] = fe_info[offset - 1][loop1];
	feature[loop3][loop1 - loop2] = '\0';
	loop2 = loop1 + 1;
	for (loop1 = loop2;
	     (loop1 < len_fe_info && fe_info[offset - 1][loop1] != ' ');
	     loop1++)
	    feature_value[loop3][loop1 - loop2] =
		fe_info[offset - 1][loop1];
	feature_value[loop3][loop1 - loop2] = '\0';
	loop2 = loop1 + 1;
	loop3++;
    }

    sprintf(log_messg, "INFO:|%s|%s|%s|%s|%s|%s|%s|%s", root1, cat1, g1, n1, p1, kase1, cm1, tam1); PRINT_LOG(log_file, log_messg);

//	exit(100);

    no_of_features = loop3;
    loop4 = 0;			/* executes when category, element of structure order is equal to category */

    while ((strcmp(order[loop4].category, category))&&loop4 <MAX_NO_OF_CAT){
		loop4++;}

    loop5 = 0;			/* executes when order[loop4].feature[loop5][0] not equal to null */


    sprintf(log_messg, "INFO:Going to enter while loop"); PRINT_LOG(log_file, log_messg);
   
//	exit(100);
 
	while (order[loop4].feature[loop5][0] != '\0') {
	not_found = 1;
	int i=0;
	for (loop3 = 0; (loop3 < no_of_features && not_found); loop3++) {
	    /* executes when order.feature not equal to tam or order.feature not equal to
	       parsarg and order.feature not equal to feature */
		
	          if (!strcmp(order[loop4].feature[loop5], feature[loop3])) {
			sprintf(log_messg,"INFO: feature value is |%s|",feature[loop3]);
			PRINT_LOG(log_file,log_messg);
			if(!strcmp(feature[loop3],"gender"))
			 strcpy(g1,feature_value[loop3]); 
			if(!strcmp(feature[loop3],"number"))
			 strcpy(n1,feature_value[loop3]); 
			if(!strcmp(feature[loop3],"person"))
			 strcpy(p1,feature_value[loop3]); 
			if(!strcmp(feature[loop3],"case"))
			 strcpy(kase1,feature_value[loop3]); 
			if(!strcmp(feature[loop3],"cm"))
			 strcpy(cm1,feature_value[loop3]); 
			if(!strcmp(feature[loop3],"tam"))
			 strcpy(tam1,feature_value[loop3]); 
			//not_found=1;
		}
    
	    if (not_found)
			printf("");
	//	struct order_info order[MAX_NO_OF_CAT];
	//loop5++;
	}
	loop5++;
	
    sprintf(log_messg, "INFO: out of for loop|g1=%s|n1=%s|p1=%s|kase1=%s|", g1, n1, p1, kase1); PRINT_LOG(log_file, log_messg);
    }
    sprintf(log_messg, "INFO:out of while loop|%s|", fs_str); PRINT_LOG(log_file, log_messg);
}

