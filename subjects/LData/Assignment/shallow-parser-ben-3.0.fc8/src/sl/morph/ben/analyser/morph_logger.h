#define	PRINT_LOG(log_file, message)	\
		{								\
			print_log(log_file, 		\
						message, 		\
						program_name,	\
						__FILE__, 		\
						__LINE__,		\
						__FUNCTION__);		\
		}



#define	PRINT_ERR(log_file, message)	\
		{								\
			print_err(log_file, 		\
				message,				\
				program_name);			\
		}


//void print_log(FILE *log_file, char *message, char *program_name, char *file_name, int line_no, char *function_name);
