# taper 'make' pour executer tout le programme
# taper 'make clean' pour nettoyer les fichiers générés
# taper 'make re' pour nettoyer et recompiler

# Nom de l'exécutable final
EXEC = prog

# Liste des fichiers sources
SRCS = main.c function.c 

# Liste des fichiers objets générés à partir des sources
OBJS = $(SRCS:.c=.o)

# Options de compilation
CFLAGS = -Wall -Wextra -Werror -g

# Compilation avec GCC
CC = gcc

# Première cible par défaut (compilation du projet)
all: $(EXEC)

# Règle pour créer l'exécutable
$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Règle générique pour compiler les fichiers objets
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Nettoyage des fichiers générés
clean:
	rm -f $(OBJS) $(EXEC)

# Cible pour nettoyer et recompiler le projet
re: clean all

# Indication pour ignorer les erreurs de fichiers inexistants
.PHONY: all clean re

