
# definition 
CC = gcc
CFLAGS = -Wall -Wextra -IcodeC
SRC_DIR = codeC
OBJ_DIR = tmp
BIN_DIR = bin
SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))
EXEC = $(BIN_DIR)/mon_programme

# Règle par défaut
all: $(EXEC)

# creation of the l'exécutable
$(EXEC): $(OBJ)
	mkdir -p $(BIN_DIR) // create bin if bin doesn't exist 
	$(CC) $^ -o $@

# Compilation des fichiers objets
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Nettoyage des fichiers temporaires et objets
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Nettoyage complet (y compris fichiers générés pour les tests)
mrproper: clean
	rm -rf tests/*.out

# Exécution de tests
test: $(EXEC)
	@echo "Lancement des tests..."
	./$(EXEC) < input/test_data.txt > tests/output.txt


