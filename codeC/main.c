#include <stdio.h>
#include <stdlib.h>
#include "function.c"


int main() {
    Node *root = NULL;
    int id, capacity, consumption;

    // Read data using scanf and insert in the AVL
    while (scanf("%d;%d;%d", &id, &capacity, &consumption) == 3) {
        root = insertAVL(root, id, capacity, consumption); 
    }
      
    // Display and free nodes in postfix order
    displayAndFree(root);

    return 0;
}
