#include "function.c"


int main() {
    AVL* tree = NULL;
    int id, capacity, consumption;

    // Read data using scanf and insert in the AVL
    while (scanf("%d;%d;%d", &id, &capacity, &consumption) == 3) {
         tree = insertAVL(tree, id, capacity, consumption); 
    }
      
    // Display and free nodes in postfix order
    displayAndFree(tree);

    return 0;
}
