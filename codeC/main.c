#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "function.h"

// ----------- MAIN -----------
int main() {
    AVL* tree = NULL;
    int id;
    long int capacity, consumption;
    
    int h = 0;

    // Read data using scanf and insert in the AVL directly each line 
    while (scanf("%d;%ld;%ld", &id, &capacity, &consumption) == 3) {
         tree = insertAVL(tree, &h, id, capacity, consumption); 
    }
      
    // Display and free nodes in postfix order
    displayAndFree(tree);

    return 0;
}


