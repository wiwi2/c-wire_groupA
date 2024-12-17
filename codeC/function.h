
#ifndef FUNCTION_H
#define FUNCTION_H

#include "structure.h"

// Function to create a new node
AVL* createNode(int id, long int capacity, long int conso);

// Function to get the max between two values
int max2(int id1, int id2); 

// Function to get the max between three values
int max3(int id1, int id2, int id3); 

// Function to get the min between two values 
int min2(int id1, int id2); 

// Function to get the min between three values
int min3(int id1, int id2, int id3); 

// Function that does a left rotation to get the tree balanced 
AVL* LeftRotation(AVL* tree);

// Function that does a right rotation to get the tree balanced     
AVL* RightRotation(AVL* tree); 

// Function that does a double left rotation (a right rotation then a left one) to get the tree equilibrated
AVL* DoubleLeftRotation(AVL* tree); 

// Function that does a double right rotation (a left rotation then a right one) to get the tree equilibrated
AVL* DoubleRightRotation(AVL* tree); 

// Function that checks the balance of the tree and decides which rotation is suitable to get it balanced if it is not... 
AVL* balancingAVL(AVL* tree); 

// AVL insert function (by ID)
AVL* insertAVL(AVL* tree, int* h, int id, long int capacity, long int conso);

// Postfix traversal to display and free nodes at the same time
void displayAndFree(AVL* tree);

#endif
