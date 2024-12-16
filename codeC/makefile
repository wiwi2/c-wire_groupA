# ----------------------- MAKEFILE -----------------------

# Name of the final executable
EXEC = prog

# List of source files
SRCS = main.c function.c

# We define the directory for object files
OBJ_DIR = ../tmp

# List of object files generated from sources
OBJS = $(SRCS:.c=.o)

# Object files with path to tmp directory
OBJ_TMP = $(addprefix $(OBJ_DIR)/, $(notdir $(OBJS)))

# Compile options
CFLAGS = -Wall -Wextra -Werror -g 

# Compilation with GCC
CC = gcc 

# First default target (project compilation)
all: $(EXEC)

# Rule to create the executable
$(EXEC): $(OBJ_TMP)
	@$(CC) $(CFLAGS) -o $@ $^ 

# Generic rule for compiling object files in the directory tmp/
$(OBJ_DIR)/%.o: %.c 
	@mkdir -p $(OBJ_DIR)  # Create the tmp directory if it does not exist
	@$(CC) $(CFLAGS) -c $< -o $@

# Cleaning generated files
clean:
	rm -rf $(OBJ_DIR) $(EXEC)

# Target to clean and recompile the project
re: clean all

# Indication to ignore non-existent file errors
.PHONY: all clean re
