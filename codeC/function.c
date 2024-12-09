// add more comments in english... 

#include <stdio.h>
#include <stdlib.h>
#include "structure.h"
 
AVL* createNodeAVL(int id, int capacity, int conso){
      // AVL declaration 
      AVL* New = malloc(sizeof(AVL)); 
      if(New==NULL){
        printf("Failed to make some space for an AVL... \nPlease try again.\n"); 
        exit(1); 
      }
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


// function that do a simple left rotation in the tree to help us keep it equilibrated 
AVL* LeftRotation(AVL* Tree){
      if(Tree == NULL){
        printf("AVL null... Please try again.");
        exit(2);
      }
      AVL* pivot; // we create a pivot that will help us do a rotation  
      int eq_a = Tree->eq; 
      int eq_p = pivot->eq; 

      pivot        = Tree->pRight; 
      Tree->pRight = pivot->pLeft; 
      pivot->pLeft = Tree; 
  
      Tree->eq  = eq_a - max2(eq_p,0) - 1; // adjusts Tree->eq based on the value of eq_p, if eq_p is positive or zero, the value will be reduced further
      pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_a - 1); // assigns pivot->eq to the smallest value among three options, based on eq_a and eq_p
      Tree      = pivot; 

      return Tree;
}

// function that do a simple right rotation in the tree to help us keep it equilibrated 
AVL* RightRotation(AVL* Tree){ 
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again.");
            exit(3); 
      }

      AVL* pivot; // we create a pivot that will help us do a rotation
      int eq_a = Tree->eq;
      int eq_p = pivot->eq;

      pivot         = Tree->pLeft;
      Tree->pleft   = pivot->pRight; 
      pivot->pRight = Tree; 

      Tree->eq  = eq_a - min2(eq_p, 0) + 1; // adjusts Tree->eq based on the comparison between eq_p and 0, then adding 1
      pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1); // assigns to pivot->eq the largest value among three expressions involving eq_a and eq_p


      Tree      = pivot; 

      return Tree; 
}


// Double left rotation : to balance the AVL Tree that we'll use to sum the consomations...
AVL* DoubleLeftRotation(AVL* Tree){
      if(Tree == NULL)
            printf("Error : AVL is NULL. Please try again."); 
            exit(4); 

      Tree->pRight = RightRotation(Tree->pRight); 
      return LeftRotation(Tree); 
}


// Double right rotation : to balance the AVL Tree that we'll use to sum the consomations...
AVL* DoubleRightRotation(AVL* Tree){
      if(Tree == NULL) 
            printf("Error : AVL is NULL. Please try again."); 
            exit(5); 

      Tree->pLeft = LeftRotation((Tree->pLeft); 
      return RightRotation(Tree); 
}



// Function to know what rotation is suitable to the situation of the AVL Tree 
AVL* balancingAVL(AVL* Tree){
      if(Tree==NULL){
            printf("Error : AVL is NULL. Please try again."); 
            exit(6); 
      }
      if(Tree->eq >= 2){ // under right tree deeper
            if(Tree->pRight->eq >=0){
                  return LeftRotation(Tree)
            }
           else{
                  return DoubleLeftRotation(Tree); 
                  }
}
      else if(Tree->eq <= -2){ // under left tree deeper
            if(Tree->pLeft->eq <= 0){
                  return RightRotation(Tree)
            }
            else{
                  return DoubleRightRotation(Tree)
                  }
      }
      return Tree; 
}


// function to insert new nodes in the AVL and returns the updated AVL 
AVL* insertAVL(AVL* Tree, int* h, int id, int capacity, int conso) {
    AVL* New = createNodeAVL(id, capacity, conso);
    if (New == NULL) {
        printf("The malloc of the new AVL node failed. Please try again.");
        exit(7);
    }

    if (Tree == NULL) {
        *h = 1; // we insert an element : the balance will change
        return New;
    }

    if (id < Tree->id) {
        Tree->pLeft = insertAVL(Tree->pLeft, h, id, capacity, conso);
        *h = -(*h); // difference of -1 if we insert on the left
    } else if (id > Tree->id) {
        Tree->pRight = insertAVL(Tree->pRight, h, id, capacity, conso);
    } else {
        // if the same node is found, we add the consumption together here !
        Tree->conso += conso;
        *h = 0;  // nothing change in the structure
        return Tree;
    }

    // Balance factor update here
    if (*h != 0) { // if there is a change
        Tree->eq = Tree->eq + *h; // ...update of balance factors
        Tree = balancingAVL(Tree);

        if (Tree->eq == 0) { // if tree is balance again...
            *h = 0; // his ancestors doo not changes
        } else {
            *h = 1;
        }
    }

    return Tree;
}


// Postfix traversal to display and free nodes
void displayAndFree(AVL* tree) {
    if (tree != NULL) {
        displayAndFree(tree->pleft);   // Process left child
        displayAndFree(tree->pRight);  // Process right child
        // Print current node in "id;capacity;total_consumption" format
        printf("%d:%d:%d\n", tree->id, tree->capacity, tree->total_consumption);
        free(tree); // Free memory from children to parents... 
    }
}




 




