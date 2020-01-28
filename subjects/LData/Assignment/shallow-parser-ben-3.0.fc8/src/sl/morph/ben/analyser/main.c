/**
  * File Name : main.c
  */



/** Function : main
  * This function is the main function where we take input word and actual flow of each function
  * from begining to ending is defined here
  * It takes arguments: argv of char type and argc of integer type
  * Return : int, 
  */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include<getopt.h>
#include<unistd.h>
#include <fcntl.h>
#include <gdbm.h>

extern void *my_fatal ();

#include "struct1.h"
#include "glbl.h"
#include "defn.h"
#include "struct.h"
#include "morph_logger.h"
#include "c_api_v2/c_api_v2.h"

/* Global Variables */
int DEBUG;
int DEBUG_NEW;
int FINDONCE;
int FOR_USER;			/* for user friendly output */
int DEFAULT_PARADIGM;		/* for choosing default paradigm if it is not
				   present in the dict */
int ALWAYS_DEFAULT_PARADIGM;	/*  always choose the default paradigm ,
				   even though entry is found in dict */
				   
char *log_messg;	/*test var----*/

int WORD_NUM;			/* for assigning word number */
int SENT_NUM;			/*for assigning sentence number */
int LINE_NUM_FLAG;		/* checks for line number is there or not */
int UWORD_DICT;			/* checks for uword dict is there or not */
int HORI_OUTPUT;		/* checks for Horizontal output  */
int YES_NO;			/* answer yes if word is present in dict */
int INFLTNL;
int sizeof_prop_noun_lex;	/* size of proper noun lexical information */
struct lex_info prop_noun_lex_ar[Lexsize];	/* lexical information structure */

char *program_name = "main";
char *log_filepath;
char *message;
FILE *log_file;


 /**
  * Prototypes of the functions in this file with a file scope
  */
extern void fgetword ();
extern void fun_close ();
extern void chk_uword_dict ();
extern void resufun ();
extern void resufun_hori ();
extern void fun_morph ();
extern char fun_read ();
extern int snt_num ();
extern int end_mark ();
extern void print_snt_num ();
extern char get_spell_variation();
extern void prnt_spell_variation();
node *data_str;

#define FUNCTION "main()"
int
main (argc, argv)
     int argc;
     char *argv[];
{
  FILE *fpt1;			/* File pointer for uword */
  FILE *fp_pdgm;		/* File pointer for pdgm_offset_info */
  FILE *fp_prop_noun_dict;	/* File pointer for prop_noun_lex.dic */
  FILE *fp_uword_dict;		/* File pointer for uword.dic */

  GDBM_FILE db_dict, db_suff, db_uword;	/* global dictionary objects */

  char morph[Morphsize];	/* morph word */
  /* filepath , filename ,filepath of dict */
  char fpath[BigArray], fname[BigArray], fpath_dict[BigArray];
  char upath[BigArray], uname[BigArray], lname[BigArray];	/* uword path, uword name */
  char line[SmallArray];
  int loop1, swit1, c, k, flag_uword, first = 1, pipe_flag;
  struct ans_struct ans_ar[Arraysize];
  /* lexical info of word , ie word,rootword, pdgm,cat */
  char uword_ans[BigArray];	/* uword ans */
  char *pdm, *uword, *dict;	/*pdm for --pdgmfilepath argument , 
				   uword for --uwordpath argument,
				   dict for --dictfilepath argument */
  extern char *optarg;
  char *infile, *outfile, iname[BigArray], oname[BigArray];    /*morphinput and output option variables */
  extern FILE *stdin;
  extern FILE *stdout;

		 

  int sizeof_uword;		/* size of uword */
  struct uword_dict uword_ar[Uwordlen];
  char morph_spell_variation[SmallArray][SmallArray];	/* morph word */
  int word_count = 0;		/* word count */
  char w;
  char final_feature_struct[LargeArray];

/* intialising variables */
  swit1 = 1;
  DEBUG = 0;
  DEBUG_NEW = 0;
  FINDONCE = 0;
  FOR_USER = 0;
  DEFAULT_PARADIGM = 0;
  ALWAYS_DEFAULT_PARADIGM = 0;
  WORD_NUM = 0;
  SENT_NUM = 0;
  LINE_NUM_FLAG = 0;
  UWORD_DICT = 0;
  HORI_OUTPUT = 0;
  YES_NO = 0;
  INFLTNL = 1;
	log_messg = (char*) malloc(sizeof(char)*256);
	memset(log_messg, '\0', 256);
	

  while (1)
    {
      static struct option long_options[] = {
	{"logfilepath", required_argument, 0, 'f'},
	{"pdgmfilepath", required_argument, 0, 'p'},
	{"uwordpath", required_argument, 0, 'u'},
	{"dictfilepath", required_argument, 0, 'd'},
	{"inputfile", required_argument, 0, 'i'},
	{"outputfile", required_argument, 0, 'o'},
	{0, 0, 0, 0}
      };
      int option_index = 0;

      k = getopt_long (argc, argv, "fpudioUFPADLHWGY",
		       long_options, &option_index);
      if (k == -1)
	break;
      switch (k)
	{
/* OPTION 'f' log file path */
	case 'f':
	  log_filepath = optarg;
	  strcpy (lname, log_filepath);
	  if ((log_file = fopen (lname, "w")) == NULL)
	    {
	      perror ("MORPH.log");
	    }
	sprintf(log_messg, "INFO:Entering into while() loop"); PRINT_LOG(log_file, log_messg);
	  PRINT_LOG (log_file, "Entering the main program\n");
	  break;

/* OPTION 'p' pdgm path */
	case 'p':
	  pdm = optarg;
	  break;
/* OPTION 'u' for uword dict path */
	case 'u':
	  uword = optarg;
	  break;
/* OPTION 'd' for dictpath */
	case 'd':
	  dict = optarg;
	  break;
/* OPTION 'U' creates a file uword which captures the words beyond the scope of the morph */
	case 'U':
	  swit1 = 0;
	  break;
    case 'i':
	      infile = optarg;
         strcpy (iname, infile);
         if ((stdin = fopen (iname, "r")) == NULL) {
		 	sprintf(log_messg, "ERROR: Could not open |%s| file\n", iname); 
            PRINT_LOG (log_file, log_messg); 
			exit (0); 
		} else 
			PRINT_LOG (log_file, "InputFile opened Sucessfully\n");
		break;
/* OPTION o for output file */ 
		case 'o': 
			outfile = optarg; 
			strcpy (oname, outfile); 
			//if ((stdout = fopen (oname, "w")) == NULL) { 
			 //	sprintf(log_messg, "ERROR: Could not open |%s| file\n", oname); PRINT_LOG (log_file, log_messg); 
			//	exit (0); 
			//} else 
			//	PRINT_LOG (log_file, "OutputFile opened Sucessfully\n"); 
		break;

																																													  

	  
/* OPTION 'F' is used for user friendly output */
	case 'F':
	  FOR_USER = 1;
	  break;
/* OPTION 'P' choose the default paradigm , if entry is not found in dict */
	case 'P':
	  DEFAULT_PARADIGM = 1;
	  break;
/* OPTION 'A' always choose the default paradigm ,even though entry is found in dict */
	case 'A':
	  ALWAYS_DEFAULT_PARADIGM = 1;
	  break;
/* OPTION 'D' dbm files are being used */
	case 'D':
	  DBM_FLAG = 1;
	  break;
/* OPTION 'L' line numbers are being provided by some other program */
	case 'L':
	  LINE_NUM_FLAG = 1;
	  break;
	case 'H':
	  HORI_OUTPUT = 1;
	  break;
/* OPTION 'W' check the Uword dict */
	case 'W':
	  UWORD_DICT = 1;
	  break;
	case 'G':
	  DEBUG = 1;
	  break;
/* OPTION 'Y' answers yes if morph recognises, else answers no */
	case 'Y':
	  YES_NO = 1;
	  break;
	default:
	  PRINT_LOG (log_file,
		     "\n\t *****USAGE***** \n\t--pdgmpath <pdgm_offset_info> --uwordpath <uword_dict_path> --dictpath <dict_path> --logfilepath <path of the log file> -ULDWH");
	  exit (0);

	  break;
	}
    }


  if (argc > 4)			/* argument is less than 3 */
    DEBUG_NEW = argv[4][0] - '0';
  if (swit1 == 0)
    {
      if ((fpt1 = fopen ("uword", "w")) == NULL)
	{

	sprintf(log_messg, "ERROR: Could not open uword file |%s| please specify the correct path\n"); PRINT_LOG(log_file, log_messg);
	  exit (-1);
	}
    }
  else {
		sprintf(log_messg, "INFO: Uword file opened successfully"); PRINT_LOG(log_file, log_messg);
	}	/* uword contains words which are 
								   beyond the scope of the morph */


  strcpy (fpath, pdm);
  strcpy (fpath_dict, uword);
  strcpy (upath, dict);
  strcpy (fname, fpath);
  strcat (fname, "/pdgm_offset_info");
  /* check for pdgm file is not readable or not */
  if ((fp_pdgm = fopen (fname, "r")) == NULL)
    {
      fprintf (log_file,
	       "ERROR in opening pdgm_offset_info file %s please specify the correct path\n",
	       fname);

      exit (0);
    }
  else
    PRINT_LOG (log_file, " pdgm_offset_info file opened Sucessfully\n");

  strcpy (uname, upath);
  // [ESC] --- Need to change this hard coded resource for multiple instance to run.
  strcat (uname, "/prop_noun_lex.dic");
  if ((fp_prop_noun_dict = fopen (uname, "r")) == NULL)	/* check for dict
							   is readable or not */
    {
      fprintf (log_file,
	       "ERROR in opening prop_noun_lex.dic file %s please specify the correct path\n",
	       uname);

      exit (0);
    }
  else
    PRINT_LOG (log_file, " prop_noun_lex.dic file opened Sucessfully\n");

  loop1 = 0;
  /* This function fetches the next wordfrom the current line of the specified file. */
  fgetword (fp_prop_noun_dict, line, ',');
  while (strcmp (line, ""))	/* comparing line with " " */
    {
      strcpy (prop_noun_lex_ar[loop1].word, line);
      /* This function fetches the next word from the current line of 
         the specified file. */
      fgetword (fp_prop_noun_dict, line, ',');
      strcpy (prop_noun_lex_ar[loop1].pdgm, line);
      /* This function fetches the next word from the current line of the specified file. */
      fgetword (fp_prop_noun_dict, line, ',');
      strcpy (prop_noun_lex_ar[loop1].cat, line);
      /* This function fetches the next word from the current line of the specified file. */
      fgetword (fp_prop_noun_dict, line, ',');
      loop1++;
    }
	sprintf(log_messg, "INFO: Added Proper Nouns into prop_noun_lex.dic, loop1 =%d", loop1); PRINT_LOG(log_file, log_messg);
  sizeof_prop_noun_lex = loop1;
  strcpy (uname, upath);
  // [ESC] --- Need to change this hard coded resource for multiple instance to run.
  strcat (uname, "/uword.dic");

/* check for uword dict is readable or not */
  if ((fp_uword_dict = fopen (uname, "r")) == NULL)
    {

      fprintf (log_file,
	       "ERROR in opening uword.dic file %s please specify the correct path\n",
	       uname);

      exit (0);
    }
  else

    PRINT_LOG (log_file, " uwrod.dic file opened Sucessfully\n");

  loop1 = 0;
  /* This function fetches the next word from the current line of the specified file. */
  fgetword (fp_uword_dict, line, ' ');
  while (strcmp (line, ""))	/* compares line with " " */
    {
      strcpy (uword_ar[loop1].sl_word, line);
      /* This function fetches the next word from the current line of the specified file. */
      fgetword (fp_uword_dict, line, '\n');
      strcpy (uword_ar[loop1].tl_word, line);
/* This function fetches the next word from the current line of the specified file. */
      fgetword (fp_uword_dict, line, ' ');
      loop1++;
    }
	sprintf(log_messg, "INFO: Added Uword into uword.dic, loop1=%d", loop1); PRINT_LOG(log_file, log_messg);
  sizeof_uword = loop1;
  if (DBM_FLAG != 1)		/* DBM_FLAG is not equal old dicts */
    {
      PRINT_LOG (log_file,
		 "\tCurrent version supports only dbm files for dictionaries. \
                        Plesae run with 'D' option\n Exiting ...\n");

      exit (1);
    }
  if (DBM_FLAG)			/* if DBM_FLAG is true */
    {
      strcpy (fname, fpath_dict);
      /* my_fatal: This function displays a message  "File not found"
         when the files dict_final,suff are not there */
      db_dict = gdbm_open (fname, 512, GDBM_READER, 0666, my_fatal (fname));
      strcpy (fname, fpath);
      strcat (fname, "/suff");
      /* my_fatal: This function displays a message  "File not found"
         when the files dict_final,suff are not there */
      db_suff = gdbm_open (fname, 512, GDBM_READER, 0666, my_fatal (fname));
      strcpy (fname, fpath);
      strcat (fname, "/uword.dbm");
      /* my_fatal: This function displays a message  "File not found"
         when the files dict_final,suff are not there */
      db_uword = gdbm_open (fname, 512, GDBM_READER, 0666, my_fatal (fname));
    }
  SENT_NUM++;
  if (LINE_NUM_FLAG == 0)	/* check for LINE_NUM_FLAG is 0 */
    if ((!HORI_OUTPUT) && !YES_NO)	/* HORI_OUTPUT AND YES_NO are not true */
      printf ("# s%d/n", SENT_NUM);
	sprintf(log_messg, "INFO: Opened GDBM database files needed to run morph"); PRINT_LOG(log_file, log_messg);
//	 c = getc (stdin);
//	 ungetc (c, stdin);
	   
	while (1) {			/* while word is there */
     // if (c == EOF)		/* checks for endof file */
     // if (c == '0')		/* checks for endof file */
//	{
	  /* Checks the end of the input conditions. if null the file exits */
//	  fun_close (fpt1, fp_pdgm, swit1, DBM_FLAG, db_dict, db_suff);
//	  exit (0);
//	}
	  /* Reads the input using API code*/
     // else {
	  	int var;
		sprintf(log_messg, "INFO: Going to read input file using SSF API"); PRINT_LOG(log_file, log_messg);
		
	  data_str = create_tree ();
	//  char filename[BigArray];
	//  scanf ("%s", filename);
		sprintf(log_messg, "INFO: SSF Input File is |%s|", iname); PRINT_LOG(log_file, log_messg);
	  read_ssf_from_file (data_str, iname);
		sprintf(log_messg, "INFO: Child count is |%d|", data_str->child_count); PRINT_LOG(log_file, log_messg);

	  for (var = 0; var < data_str->child_count; var++) {
	      char feature_str[BiggerArray];
	      feature_str[0] = '\0';
		  // [ESC] --- no check for return from function
	      node *child = get_nth_child (data_str, var);

	      /* this function reads the input word */
		sprintf(log_messg, "INFO: Going to call fun_read()"); PRINT_LOG(log_file, log_messg);
	      c = fun_read(morph, get_field(child, 1));
		sprintf(log_messg, "INFO: Returned from fun_read(), c = |%d| count=%d|word=%s|\n", c, var, morph); PRINT_LOG(log_file, log_messg);
		  //if((!strcmp(morph,"."))||(!strcmp(morph,"?"))) ispunct
		  //if (ispunct(morph[0])) {
		  //sprintf(final_feature_struct, "<fs af='%c,punc,,,,,,'>", morph[0]); PRINT_LOG(log_file, final_feature_struct);
		  //}

	    // if (!strcmp (morph, "."))	/* checks for the given word is NOT WORD */
	//	{
		  /* Checks the end of the input conditions. if null the file exits */
		  //delete_node (get_nth_child(data_str, data_str->child_count - 1));
		  //print_tree (data_str);
		  //fun_close (fpt1, fp_pdgm, swit1, DBM_FLAG, db_dict,
		//	     db_suff);
		 // exit (0);
	//	}

		  /* checks for morph is null or not */
	      if (strcmp(morph, "\0"))	{
			sprintf(log_messg, "INFO: Input word is |%s|", morph); PRINT_LOG(log_file, log_messg);
		  FINDONCE = 0;
		  /* checks fo r line no. , snt no., and o/p are there or not */
		  if ((LINE_NUM_FLAG && snt_num (morph)) && (!HORI_OUTPUT)
		      && (!YES_NO))
		    /* snt_num() This function marks a sentence number to the word */
		    print_snt_num (morph);
		  else		/* checks fo r line no. , snt no., and o/p are there  */
		    {
		      WORD_NUM++;
		      if (FOR_USER && !HORI_OUTPUT)	/* o/p is not there */
			printf ("@input_word@\n word_num: w%d\n", WORD_NUM);
		      else
			/* if answer is not there and hori_output is not there */
		      if (!HORI_OUTPUT && !YES_NO)
			printf ("input_word\nw%d\n", WORD_NUM);
		      if ((morph[0] == '@') || (LINE_NUM_FLAG && end_mark (morph)))	/* morph= @ */
			{
			  if (!HORI_OUTPUT)	/*checks for output not there */
			    printf ("AVY\n%s\n", morph);	/* print the marked words as they are */
			  else
			    printf ("%s", morph);	/* print the marked words as they are */
			}
		      else
			{
			  /* This function checks the Unkown word is present in the UDictionary or not */
			  chk_uword_dict(morph, uword_ar->sl_word, sizeof_uword, 
			  					sizeof (uword_ar[0]), strcmp, 
								uword_ans, DBM_FLAG, db_uword);
			  /* checks for uword not null and uword_dict is there */
			  if ((uword_ans[0] != '\0') && (UWORD_DICT))
			    if (!HORI_OUTPUT && !YES_NO)	/* checks output and answer not there */
			      printf ("AVY\n%s\n", uword_ans);
			    else if (YES_NO)	/* if answer is there */
			      printf ("%s", morph);
			    else	/* if answer is not there */
			      printf ("%s", uword_ans);
			  else
			    {
			      /* This function is the main functuon. It extracts suffixes and calls different routines for
			         analysis */
				sprintf(log_messg, "INFO: Calling fun_morph() for the word |%s|", morph); PRINT_LOG(log_file, log_messg);
				fun_morph (morph, swit1, fpt1, fp_pdgm, DBM_FLAG, db_dict, db_suff, ans_ar);
				loop1=0;
				sprintf(log_messg, "INFO: fun_morph() returned |%d|%s|%d|%s|", loop1, ans_ar[loop1].root, ans_ar[var].offset, ans_ar[var].pdgm); PRINT_LOG(log_file, log_messg);

				  /* if offest is equal to -2 for UNKNOWN Word*/
			      if (ans_ar[0].offset == -2)	{
				  if (YES_NO)	/* checks for ajFAwa */
				    printf ("%s<ajFAwa>", morph);
				  	if (swit1 == 0)
				    {
				      char root[BigArray], cat[BigArray],
					g[BigArray], n[BigArray], p[BigArray],
					kase[BigArray], cm[BigArray],
					tam[BigArray];
			sprintf(final_feature_struct, "<fs af='%s,unk,,,,,,'>", morph);
				    }
					}

			      else	/* checks for morph is there */
				{
				  if (YES_NO)	/* checks for answer is true */
				    printf ("%s", morph);
				  else	/* if answer is not there */
				    {
				      loop1 = 0;
				      pipe_flag = 0;
					  /* checks for offset is not eual to -2 */
				      while (ans_ar[loop1].offset != -2) {
				sprintf(log_messg, "INFO: Reading Analysis for word no.= |%d|", loop1); PRINT_LOG(log_file, log_messg);
						
  					  if (ans_ar[loop1].offset == -1) {	/* checks for offset is not eual to -1 */
					    if (!HORI_OUTPUT) {	/* if output not there */
					      printf ("Avy\n%s\n", ans_ar[loop1].root);
					    } else {
					      printf ("%s{Avy}", ans_ar[loop1].root);
							sprintf(feature_str, "<fs af='%s,avy,,,,,,'>", ans_ar[loop1].root);
						  }
					  } else if (ans_ar[loop1].offset == -3) {	/* Case of Numeral */
					    if (!HORI_OUTPUT) {	/* if output not there */
					      printf ("Avy\n%s\n", ans_ar[loop1].root);
					    } else {	/* if answer is there */
					      //printf ("%s", ans_ar[loop1].root);
						if (ispunct(ans_ar[loop1].root[0])) {
							sprintf(feature_str, "<fs af='%c,punc,,,,,,'>", ans_ar[loop1].root[0]);
						} else { 
							sprintf(feature_str, "<fs af='%s,num,,,,,,'>", ans_ar[loop1].root);
						 }
						sprintf(log_messg, "INFO: NUMERALS, SPECIAL, & PUNCTUATIONS |%s|", ans_ar[loop1].root); PRINT_LOG(log_file, log_messg);
						  }
					  } else if (HORI_OUTPUT) {
					      /* This function prints the output in horizontal way for the given input word */
					      char root[BigArray],
						cat[BigArray], g[BigArray],
						n[BigArray], p[BigArray],
						kase[BigArray],
						cm[BigArray], tam[BigArray];

						  memset(g, '\0', sizeof(g));
                                                memset(n, '\0', sizeof(n));
                                                memset(p, '\0', sizeof(p));
                                                memset(kase, '\0', sizeof(kase));
                                                memset(cm, '\0', sizeof(cm));
                                                memset(tam, '\0', sizeof(tam));


						resufun_hori(ans_ar[loop1].root, ans_ar[loop1].pdgm, ans_ar[loop1].offset, 
										ans_ar[loop1].aux_verb, root, cat, g, n, p, kase, cm, tam);
						sprintf(log_messg, "INFO: resfun_hori returns|%s|%s|%s|%s|%s|%s|%s|%s|", root, cat, g, n, p, kase, cm, tam); PRINT_LOG(log_file, log_messg);

if(!strcmp(cat,"n")||!strcmp(cat,"pn"))
                {
sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, cm, cm);
                }
                else {
		if(!strcmp(cat,"v"))
                {
sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, tam, tam);   
                }
		else
		sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, cm, tam);
		}
						


//	sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, cm, tam);
							//sprintf(log_messg, "INFO: %s", feature_str); PRINT_LOG(log_file, log_messg);
					    } else {

					      char root[BigArray],
						cat[BigArray], g[BigArray],
						n[BigArray], p[BigArray],
						kase[BigArray],
						cm[BigArray], tam[BigArray];

					      /* This function prints the root, pdgm,priority ,category */
		if(!strcmp(cat,"n")||!strcmp(cat,"pn"))
		{
sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, cm, cm);
		}
		else {
		if(!strcmp(cat,"v"))
		{
sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, tam, tam);		
		}
		else
		sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, cm, tam);
	}
						PRINT_LOG(log_file, feature_str);
					      resufun(ans_ar[loop1].root,
						       ans_ar[loop1].pdgm,
						       ans_ar[loop1].offset,
						       ans_ar[loop1].aux_verb,
						       root, cat, g, n, p,
						       kase, cm, tam);
						//sprintf(feature_str, "<fs af='%s,%s,%s,%s,%s,%s,%s,%s'>", root, cat, g, n, p, kase, cm, tam);

					    }

					  strcpy (ans_ar[loop1].root, "");
					  ans_ar[loop1].offset = 0;
					  strcpy (ans_ar[loop1].aux_verb, "");
					  strcpy (ans_ar[loop1].pdgm, "");
					  if (loop1 == 0) {
					  	//memset(feature_str, '\0', sizeof(feature_str));
						sprintf(final_feature_struct, "%s", feature_str);
					  } else {
						sprintf(final_feature_struct, "%s|%s", final_feature_struct, feature_str);	
					  }
						sprintf(log_messg, "lopp1 is |%d| and FS=%s", loop1, final_feature_struct); PRINT_LOG(log_file, log_messg);
					  loop1++;
					}
				    }
				}
			    }
			}
		    }
		  if ((c == '.') || (c == '?'))	/* if for c is equal to '.' '?' */ {
		      WORD_NUM++;
		      if (!HORI_OUTPUT && !YES_NO)	/* This function prints the output in horizontal way for the given input word */
			printf ("input_word\nw%d\nAVY\n%c\n", WORD_NUM, c);
		      else if (!YES_NO)
		//	printf ("%c\n", c);
			printf ("");
		      else
		//	printf ("%c", c);
						sprintf(final_feature_struct, "<fs af='%s,punc,,,,,,'>",c);
		      SENT_NUM++;
						sprintf(final_feature_struct, "<fs af='%s,punc,,,,,,'>",c);

		    }

		}
			sprintf(log_messg, "INFO: Input word is null"); PRINT_LOG(log_file, log_messg);
	      child->OR = read_or_node(final_feature_struct);
			sprintf(log_messg, "INFO: YOU ARE HERE"); PRINT_LOG(log_file, log_messg);
	    } /*no more childs to process */
			
		  //delete_node (get_nth_child(data_str, data_str->child_count - 1));
		  //print_tree (data_str);
		  print_tree_to_file(data_str, outfile);
		  fun_close (fpt1, fp_pdgm, swit1, DBM_FLAG, db_dict, db_suff);

		sprintf(log_messg, "INFO: OUT of for"); PRINT_LOG(log_file, log_messg);
		exit(0);
//	}
	sprintf(log_messg, "INFO: OUT of else"); PRINT_LOG(log_file, log_messg);
    }
	sprintf(log_messg, "INFO: END OF WHILE"); PRINT_LOG(log_file, log_messg);

}
