/**
 * File Name :order_ssf.c
 */

/**
  * this file is required to order the output in SSF 
  */

 
#include "struct.h"
struct order_ssf_info order[11]={
{
"v",           /* for verb */
"gender",      /* gender */
"number",      /* number */
"person",      /* person */
"case",
"cm",
"tam",         /* suffix indicating Tense Aspect Modality */
},
{
"vn",
"gender",
"number",
"person",
"case",
"cm",
"tam",
},
{
"n",       /*lexical category for noun */ 
"gender",  /* "gender"er */
"number",  /* number */
"person",  /* person */
"case",	   /* case */
"cm",
"parsarg", /* parsarg */
},
{
"pn", //"p"
"gender",  /* "gender"er */
"number",  /* number */
"person",  /* person */
"case",	   /* case */
"cm",
"tam", /* parsarg */
},
{
"adj",        /* for Adjective */
"gender",     /* "gender"er */
"number",     /* number */
"person",     /* person */
"case",	      /* case */
"cm",
"tam",       /* complete suff */
},
{
"P",          /* lexical category */
"gender",     /* "gender"er */
"number",     /* number */
"person",     /* person */
"case",	      /* case */
"cm",
"tam",       /* complete suffix */
},
{
"Avy",
"gender",     /* "gender"er */
"number",     /* number */
"person",     /* person */
"case",	      /* case */
"cm",
"tam",       /* complete suffix */
},
{
"avy",
"gender",     /* "gender"er */
"number",     /* number */
"person",     /* person */
"case",	      /* case */
"cm",
"tam",       /* complete suffix */
},
/* Added for Sanskrit, avy is better than Avy, Hint: view in devenagari */
/* Afterwords delete Avy category, and also make changes in Ca Ce Fe files of other langauges. */
{
"sh_n",
"number",
"gender",
"number1",
"case",
"cm",
"tam",
},
{
"D",
"gender",
"number",
"person",
"case",
"cm",
"tam",
},
{
"sh_P",
"person",
"number",
"gender",
"number1",
"case",
"cm",
"tam",
}
};
