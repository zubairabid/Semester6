 char map[] = "zMHaAiIuUqVeEYVoOYkKgGfcCjJFtTdDNwWxXnYpPbBmyYrYlYYvSRsh AiIuUqVeEYVoOY_Z.";
 char ch1,ch2;
SPECIAL_CATEGORY [���]
VOWEL_ALL [���������������]
VOWEL [�����������]
VOWEL_DRVD [��]
VOWEL_ENGL [��]
HALANT �
NUKTA �
VOWEL_MATRA_ALL [��������������]
VOWEL_MATRA [����������]
VOWEL_MATRA_DRVD [��]
VOWEL_MATRA_ENGL [��]
CONSONANT_SYLLABIC [���������������������������������]
CONSONANT_SYLLABIC_ADTNL [�����]
CONSONANT_SYLLABIC_ADTNL_1 [����]
CONSONANT_SYLLABIC_ADTNL_2 �
CONSONANT_SYLLABIC_nY �
CONSONANT_SYLLABIC_yY �
CONSONANT_SYLLABIC_rY �
CONSONANT_SYLLABIC_lY �
CONSONANT_SYLLABIC_lYY �
ROM_WORD [A-Za-z]+
%%
@{ROM_WORD}				{
					printf("%s",yytext);
					}
{ROM_WORD}				{
					printf("@");ECHO;
					}
{CONSONANT_SYLLABIC}			{
					ch1 = map[95 + yytext[0]];
					printf("%ca",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_1}		{
					ch1 = map[95 + yytext[0]-1];
					printf("%cYa",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_2}		{
					ch1 = map[95 + yytext[0]-2];
					printf("%cYYa",ch1);
					}

{CONSONANT_SYLLABIC}{HALANT}		{
					ch1 = map[95 + yytext[0]];
					printf("%c",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{HALANT}	{
					ch1 = map[95 + yytext[0]-1];
					printf("%cY",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{HALANT}	{
					ch1 = map[95 + yytext[0]-2];
					printf("%cYY",ch1);
					}

{CONSONANT_SYLLABIC}{VOWEL_MATRA}	{
					ch1=map[95 + yytext[0]];
                                        ch2=map[95 + yytext[1]];
                                        printf("%c%c",ch1,ch2);
					}

{CONSONANT_SYLLABIC}{VOWEL_MATRA_DRVD}	{
					ch1=map[95 + yytext[0]];
                                        ch2=map[95 + yytext[1]+1];
					printf("%c%cV",ch1,ch2);
					}

{CONSONANT_SYLLABIC}{VOWEL_MATRA_ENGL}	{
					ch1=map[95 + yytext[0]];
                                        ch2=map[95 + yytext[1]-1];
					printf("%c%cY",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{VOWEL_MATRA} {
                                        ch1=map[95 + yytext[0]-1];
                                        ch2=map[95 + yytext[1]];
					printf("%cY%c",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{VOWEL_MATRA_DRVD} {
                                        ch1=map[95 + yytext[0]-1];
                                        ch2=map[95 + yytext[1]+1];
					printf("%cY%cV",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{VOWEL_MATRA_ENGL} {
                                        ch1=map[95 + yytext[0]-1];
                                        ch2=map[95 + yytext[1]-1];
					printf("%cY%cY",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{VOWEL_MATRA} {
                                        ch1=map[95 + yytext[0]-2];
                                        ch2=map[95 + yytext[1]];
					printf("%cYY%c",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{VOWEL_MATRA_DRVD} {
                                        ch1=map[95 + yytext[0]-2];
                                        ch2=map[95 + yytext[1]+1];
					printf("%cYY%cV",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{VOWEL_MATRA_ENGL} {
                                        ch1=map[95 + yytext[0]-2];
                                        ch2=map[95 + yytext[1]-1];
					printf("%cYY%cY",ch1,ch2);
					}

{VOWEL}					{
                                        ch1=map[95 + yytext[0]];
					printf("%c",ch1);
					}

{VOWEL_DRVD}				{
                                        ch1=map[95 + yytext[0]+1];
					printf("%cV",ch1);
					}

{VOWEL_ENGL}				{
                                        ch1=map[95 + yytext[0]-1];
					printf("%cY",ch1);
					}

{SPECIAL_CATEGORY}			{
                                        ch1=map[95 + yytext[0]];
					printf("%c",ch1);
					}

{VOWEL_MATRA}				{
                                        ch1=map[95 + yytext[0]];
					printf("%c",ch1);
					}

{VOWEL_MATRA_DRVD}			{
                                        ch1=map[95 + yytext[0]+1];
					printf("%cV",ch1);
					}

{VOWEL_MATRA_ENGL}			{
                                        ch1=map[95 + yytext[0]-1];
					printf("%cY",ch1);
					}

{HALANT}				{
                                        ch1=map[95 + yytext[0]];
					printf("%c",ch1);
					}

{NUKTA}					{
                                        ch1=map[95 + yytext[0]];
					printf("%c",ch1);
					}

{CONSONANT_SYLLABIC}{NUKTA}		{
                                        ch1=map[95 + yytext[0]];
					printf("%cZa",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{NUKTA}	{
                                        ch1=map[95 + yytext[0]-1];
					printf("%cYZa",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{NUKTA}	{
                                        ch1=map[95 + yytext[0]-2];
					printf("%cYYZa",ch1);
					}

{CONSONANT_SYLLABIC}{NUKTA}{HALANT}	{
                                        ch1=map[95 + yytext[0]];
					printf("%cZ",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{NUKTA}{HALANT} {
                                        ch1=map[95 + yytext[0]-1];
					printf("%cZY",ch1);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{NUKTA}{HALANT} {
                                        ch1=map[95 + yytext[0]-2];
					printf("%cZYY",ch1);
					}

{CONSONANT_SYLLABIC}{NUKTA}{VOWEL_MATRA} {
                                        ch1=map[95 + yytext[0]];
                                        ch2=map[95 + yytext[2]];
					printf("%cZ%c",ch1,ch2);
					}

{CONSONANT_SYLLABIC}{NUKTA}{VOWEL_MATRA_DRVD}	{
                                        ch1=map[95 + yytext[0]];
                                        ch2=map[95 + yytext[2]+1];
					printf("%cZ%cV",ch1,ch2);
					}

{CONSONANT_SYLLABIC}{NUKTA}{VOWEL_MATRA_ENGL}	{
                                        ch1=map[95 + yytext[0]];
                                        ch2=map[95 + yytext[2]-1];
					printf("%cZ%cY",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{NUKTA}{VOWEL_MATRA} {
                                        ch1=map[95 + yytext[0]-1];
                                        ch2=map[95 + yytext[2]];
					printf("%cYZ%c",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{NUKTA}{VOWEL_MATRA_DRVD} {
                                        ch1=map[95 + yytext[0]-1];
                                        ch2=map[95 + yytext[2]+1];
					printf("%cYZ%cV",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_1}{NUKTA}{VOWEL_MATRA_ENGL} {
                                        ch1=map[95 + yytext[0]-1];
                                        ch2=map[95 + yytext[2]-1];
					printf("%cYZ%cY",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{NUKTA}{VOWEL_MATRA} {
                                        ch1=map[95 + yytext[0]-2];
                                        ch2=map[95 + yytext[2]];
					printf("%cYYZ%c",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{NUKTA}{VOWEL_MATRA_DRVD} {
                                        ch1=map[95 + yytext[0]-2];
                                        ch2=map[95 + yytext[2]+1];
					printf("%cYYZ%cV",ch1,ch2);
					}

{CONSONANT_SYLLABIC_ADTNL_2}{NUKTA}{VOWEL_MATRA_ENGL} {
                                        ch1=map[95 + yytext[0]-2];
                                        ch2=map[95 + yytext[2]-1];
					printf("%cYYZ%cY",ch1,ch2);
					}

�{NUKTA}				{
					printf("Q");
					}

�{NUKTA}				{
					printf("Q");
					}

{CONSONANT_SYLLABIC}�{NUKTA}			{
                                        ch1=map[95 + yytext[0]];
					printf("%cQ",ch1);
					}

�{NUKTA}				{
					printf("L");
					}

�{NUKTA}				{
					printf("L");
					}

{CONSONANT_SYLLABIC}�{NUKTA}			{
                                        ch1=map[95 + yytext[0]];
					printf("%cL",ch1);
					}
