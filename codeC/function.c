#include <stdio.h> 
#include <stdlib.h>
#include <string.h>

#include "structure.h"

// createNodeAVL : creates a node that will represent a station in the AVL Tree
AVL* createNodeAVL(int id, long int capacity, long int conso){
      AVL* New = malloc(sizeof(AVL)); 
      if(New==NULL){
        printf("Failed to make some space for an AVL... \nPlease try again.\n"); // Immediate stop if the allocation failed
        exit(1); 
      }
   // We give the values ​​to the new node...      
      New->station_id = id; 
      New->capacity   = capacity; 
      New->sum_conso  = conso; 
      New->pLeft      = NULL; 
      New->pRight     = NULL; 
      New->eq         = 0; 

return New;
}

// max2 : finds the max between two values 
int max2(int id1, int id2){
      if(id1 > id2){
            return id1; 
      }
      else{
            return id2;
      }
}

// max3 : finds the max between three values 
int max3(int id1, int id2, int id3){
      if(id1 > id2 && id1 > id3){
            return id1; 
      }
      else if(id2 > id1 && id2 > id3){
            return id2;
      }
      else{
            return id3; 
      }
}


// min2 : finds the min between two values 
int min2(int id1, int id2){
      if(id1 < id2){
            return id1; 
      }
      else{
            return id2;
      }
}


// min3 : finds the min between three values 
int min3(int id1, int id2, int id3){
      if(id1 < id2 && id1 < id3){
            return id1; 
      }
      else if(id2 < id1 && id2 < id3){
            return id2;
      }
      else{
            return id3; 
      }
}


// LeftRotation : does a simple left rotation in the tree to help us keep it balanced 
AVL* LeftRotation(AVL* Tree){
      if(Tree == NULL){
        printf("AVL null... Please try again.");
        exit(2);
      }
      AVL* pivot; // We create a pivot that will help us do a rotation  

      pivot        = Tree->pRight; // Here, the pivot becomes the tree's right son
      Tree->pRight = pivot->pLeft; // And the tree's right son becomes the pivot's left son (NULL if it doesn't exist)
      pivot->pLeft = Tree; // Then, the pivot's left son becomes the tree, and the rotation is done 

      int eq_a = Tree->eq; 
      int eq_p = pivot->eq; 

      // Update balance factors (from the lecture course) 
      Tree->eq  = eq_a - max2(eq_p,0) - 1; 
      pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_a - 1); 
      Tree      = pivot; 

      return Tree; 
}

// RightRotation : does a simple right rotation in the tree to help us keep it balanced 
AVL* RightRotation(AVL* Tree){ 
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again.");
            exit(3); 
      }

      AVL* pivot; // We create a pivot that will help us do a rotation

      int eq_a; 
      int eq_p; 

      pivot         = Tree->pLeft; // Here, the pivot becomes the tree's left son
      Tree->pLeft   = pivot->pRight; // And the tree's left son becomes the pivot's right  son (NULL if it doesn't exist)
      pivot->pRight = Tree; // Then, the pivot's right son becomes the tree, and the rotation is done 

      eq_a       = Tree->eq;
      eq_p       = pivot->eq; 

      // Update balance factors (from the lecture course) 
      Tree->eq  = eq_a - min2(eq_p, 0) + 1; 
      pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1); 
      Tree      = pivot; 

      return Tree; 
}


// Double left rotation : balances the AVL Tree that we'll use to sum the consumptions...
AVL* DoubleLeftRotation(AVL* Tree){
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again."); // Immediate stop if the allocation failed
            exit(4); 
}
      Tree->pRight = RightRotation(Tree->pRight); // We first do a right rotation 
      return LeftRotation(Tree); // To finish with a left one 
}


// Double right rotation : balances the AVL Tree that we'll use to sum the consomations...
AVL* DoubleRightRotation(AVL* Tree){
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again."); // Immediate stop if the allocation failed
            exit(5); 
	}
      Tree->pLeft = LeftRotation(Tree->pLeft); // We first do a left rotation 
      return RightRotation(Tree); // To finish with a right one 
}



// balancingAVL : checks the tree's balance and determines which rotation is suitable for the AVL Tree's balance therefore
AVL* balancingAVL(AVL* Tree){
      if(Tree==NULL){
            printf("Error : AVL is NULL. Please try again."); 
            exit(6);   
      }
      if(Tree->eq >= 2){
	      // Case where the tree is unbalanced on the right
            if(Tree->pRight->eq >=0){ 
                  return LeftRotation(Tree); // We do a simple left rotation
            }
           else{
                  return DoubleLeftRotation(Tree); // We do a double left rotation
                  }
}
      else if(Tree->eq <= -2){
	      // Case where the tree is unbalanced on the left
            if(Tree->pLeft->eq <= 0){
                  return RightRotation(Tree); // We do a simple right rotation
            }
            else{
                  return DoubleRightRotation(Tree); // We do a double right rotation 
                  }
      }
      return Tree; 
}


// InsertAVL: inserts a new node in the AVL and returns the updated AVL 
AVL* insertAVL(AVL* tree, int* h, int id, long int capacity, long int conso) { 
    if (tree == NULL) {
        AVL* New = createNodeAVL(id, capacity, conso); // If the tree is empty, create a new node
        if (New == NULL) {
            printf("The creation of the new AVL node failed. Please try again.");
            exit(7);
        }
        *h = 1; // The height increases
        return New;
    }

    if (id < tree->station_id) {
        // If the element id is smaller than the root's element id, we insert it on the left...
        tree->pLeft = insertAVL(tree->pLeft, h, id, capacity, conso); // ...recursively
        *h = -(*h); // If added on the left side of the tree, the node makes the balance factor negative
    } 
    else if (id > tree->station_id) { // If the id is greater, we insert it on the right
        tree->pRight = insertAVL(tree->pRight, h, id, capacity, conso); // and always recursively
    } 
    else { // Case where the element is already present in the tree 
        tree->sum_conso += conso;
        *h = 0; // The height isn't changed
        return tree;
    }

    // Update the balance factors
    if (*h != 0) {
        tree->eq = tree->eq + *h;
        tree = balancingAVL(tree); // Balance the tree in this function...

        if (tree->eq == 0) { // If the balance factor of the tree is 0, then the tree is perfectly balanced 
            *h = 0;
        } 
        else {
            *h = 1; 
        }
    }

    return tree;
}


// displayAndFree : goes through the AVL tree, display every node from the children to the parents and free it
void displayAndFree(AVL* tree) {
    if (tree != NULL) {
        displayAndFree(tree->pLeft);   // Process left child
        displayAndFree(tree->pRight);  // Process right child
        // It prints the current node in "id:capacity:sum_conso" format
        printf("%d:%ld:%ld\n", tree->station_id, tree->capacity, tree->sum_conso);
        free(tree); // Free memory from children to parents... 
    }
}





