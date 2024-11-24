# taper 'make' pour executer tout le programme
# taper 'make clean' pour nettoyer les fichiers générés
# taper 'make re' pour nettoyer et recompiler


// à switch en anglais 


# Nom de l'exécutable final
EXEC = prog

# Liste des fichiers sources
SRCS = main.c function.c

# Répertoire pour les fichiers objets
OBJ_DIR = tmp

# Liste des fichiers objets générés à partir des sources
OBJS = $(SRCS:.c=.o)

# Fichiers objets avec le chemin vers le répertoire tmp
OBJ_TMP = $(addprefix $(OBJ_DIR)/, $(notdir $(OBJS)))

# Options de compilation
CFLAGS = -Wall -Wextra -Werror -g

# Compilation avec GCC
CC = gcc

# Première cible par défaut (compilation du projet)
all: $(EXEC)

# Règle pour créer l'exécutable
$(EXEC): $(OBJ_TMP)
	$(CC) $(CFLAGS) -o $@ $^

# Règle générique pour compiler les fichiers objets dans tmp/
$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(OBJ_DIR)  # Crée le répertoire tmp s'il n'existe pas
	$(CC) $(CFLAGS) -c $< -o $@

# Nettoyage des fichiers générés
clean:
	rm -rf $(OBJ_DIR) $(EXEC)

# Cible pour nettoyer et recompiler le projet
re: clean all

# Indication pour ignorer les erreurs de fichiers inexistants
.PHONY: all clean re
