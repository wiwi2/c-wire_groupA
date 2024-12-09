
#include "structure.h"
#ifndef FUNCTION_H
#define FUNCTION_H


// Function to create a new node
AVL* createNode(int id, int capacity, int total_consumption);

// Function to get the max between two values
int max2(int id1, int id2); 

// Function to get the max between three values
int max3(int id1, int id2, int id3); 

// Function to get the min between two values 
int min2(int id1, int id2); 

// Function to get the min between three values
int min3(int id1, int id2, int id3); 

// Function that do a left rotation to get the tree equilibrated 
AVL* LeftRotation(AVL* tree);

// Function that do a right rotation to get the tree equilibrated     
AVL* RightRotation(AVL* tree); 

// Function that do a double left rotation (a right rotation then a left one) to get the tree equilibrated
AVL* DoubleLeftRotation(AVL* tree); 

// Function that do a double right rotation (a left rotation then a right one) to get the tree equilibrated
AVL* DoubleRightRotation(AVL* tree); 

// Function that checks the balance of the tree and decide what rotation is suitable to get it equilibrated if it's not... 
AVL* balancingAVL(AVL* tree); 

// AVL insert function (by ID)
AVL* insertAVL(Node *root, int id, int capacity, int total_consumption);

// Postfix traversal to display and free nodes at the same time
void displayAndFree(Node *root);

#endif

