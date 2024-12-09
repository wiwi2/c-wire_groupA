#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "function.h"


int main() {
    AVL* tree = NULL;
    int id, capacity, consumption;
    
    int h = 0;

    // Read data using scanf and insert in the AVL
    while (scanf("%d;%d;%d", &id, &capacity, &consumption) == 3) {
         tree = insertAVL(tree, &h, id, capacity, consumption); 
    }
      
    // Display and free nodes in postfix order
    displayAndFree(tree);

    return 0;
}
