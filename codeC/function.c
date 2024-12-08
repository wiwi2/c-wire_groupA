// add more comments in english... 

#include <stdio.h>
#include <stdlib.h>
#include "structure.h"

AVL* createNodeAVL(int id, int capacity, int conso){
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
max2(int id1, int id2){
      if(id1 > id2){
            return id1; 
      }
      else{
            return id2;
      }
}

// max3 : finds the max between three values 
max3(int id1, int id2, int id3){
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
min2(int id1, int id2){
      if(id1 < id2){
            return id1; 
      }
      else{
            return id2;
      }
}


// min3 : finds the min between three values 
max3(int id1, int id2, int id3){
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

      int eq1; 
      int eq2; 

      pivot        = Tree->pRight; 
      Tree->pRight = pivot->pLeft; 
      pivot->pLeft = Tree; 

      eq_a = Tree->eq; 
      eq_p = pivot->eq; 
  
      Tree->eq  = eq_a - max2(eq_p,0) - 1; 
      pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_a - 1); 
      Tree      = pivot; 

      return Tree;
}


AVL* RightRotation(AVL* Tree){ // à faire comme celle d'avant 
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again.");
            exit(2); 
      }

      AVL* pivot; 

      int eq_a; 
      int eq_p; 

      pivot         = Tree->pLeft;
      Tree->pleft   = pivot->pRight; 
      pivot->pRight = Tree; 

      eq_a       = Tree->eq;
      eq_p       = pivot->eq; 

      Tree->eq  = eq_a - min2(eq_p, 0) + 1; 
      pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1); 
      Tree      = pivot; 

      return Tree; 
}


// Double left rotation : to equilibrate the AVL Tree that we'll use to sum the consomations...
AVL* DoubleLeftRotation(AVL* Tree)
      if(Tree == NULL)
            printf("Error : AVL is NULL. Please try again."); 
            exit(..); 

      Tree->pRight = RightRotation(Tree->pRight); 
      return LeftRotation(Tree); 


// Double right rotation
AVL* DoubleRightRotation(AVL* Tree)
      if(Tree == NULL) 
            printf("Error : AVL is NULL. Please try again."); 
            exit(..); 

      Tree->pLeft = LeftRotation((Tree->pLeft); 
      return RightRotation(Tree); 


// Function to know what rotation is suitable to the situation of the AVL Tree 
AVL* equilibrageAVL(AVL* Tree){
      if(Tree==NULL){
            printf("Error : AVL is NULL. Please try again."); 
            exit(..); 
      }
      if(Tree->eq >= 2){
            if(Tree->pRight->eq >=0){
                  return leftRotation(Tree)
            }
           else{
                  return DoubleLeftRotation(Tree); 
                  }
}
      else if(Tree->eq <= -2){
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
AVL insertAVL(AVL* Tree, int* h, int id, int capacity, int conso) {
    AVL* New = createNodeAVL(id, capacity, conso);
    if (New == NULL) {
        printf("The malloc of the new AVL node failed. Please try again.");
        exit(1);
    }

    if (Tree == NULL) {
        *h = 1;
        return New;
    }

    if (id < Tree->id) {
        Tree->pLeft = insertAVL(Tree->pLeft, h, id, capacity, conso);
        *h = -(*h);
    } else if (id > Tree->id) {
        Tree->pRight = insertAVL(Tree->pRight, h, id, capacity, conso);
    } else {
        // if the same node is found, we add the consumption together here !
        Tree->conso += conso;
        *h = 0;  // nothing change in the structure
        return Tree;
    }

    // Balance factor update here
    if (*h != 0) {
        Tree->eq = Tree->eq + *h;
        Tree = equilibrageAVL(Tree);

        if (Tree->eq == 0) {
            *h = 0;
        } else {
            *h = 1;
        }
    }

    return Tree;
}


// Postfix traversal to display and free nodes
void displayAndFree(Node *root) {
    if (root) {
        displayAndFree(root->left);   // Process left child
        displayAndFree(root->right);  // Process right child
        // Print current node in "id;capacity;total_consumption" format
        printf("%d;%d;%d\n", root->id, root->capacity, root->total_consumption);
        free(root); // Free memory from children to parents... 
    }
}




 




