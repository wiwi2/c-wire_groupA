
#include "structure.h"
#ifndef FUNCTION_H
#define FUNCTION_H


// Function to create a new node
Node* createNode(int id, int capacity, int total_consumption);
    
// AVL insert function (by ID)
Node* insertAVL(Node *root, int id, int capacity, int total_consumption);

// Postfix traversal to display and free nodes
void displayAndFree(Node *root);

#endif

