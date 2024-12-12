#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "structure.h"

AVL* createNodeAVL(int id, int capacity, int conso){
      AVL* New = malloc(sizeof(AVL)); 
      if(New==NULL){
        printf("Failed to make some space for an AVL... \nPlease try again.\n"); //immediate stop if the allocation failed
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

      pivot        = Tree->pRight; //the right's son become the pivot
      Tree->pRight = pivot->pLeft; 
      pivot->pLeft = Tree; 

      int eq_a = Tree->eq; 
      int eq_p = pivot->eq; 

	//update of equilibrium factors
      Tree->eq  = eq_a - max2(eq_p,0) - 1; 
      pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_a - 1); 
      Tree      = pivot; 

      return Tree; //Tree become the new root
}

//function that do a simple right rotation in the tree to help us keep it equilibrated
AVL* RightRotation(AVL* Tree){ 
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again.");
            exit(2); 
      }

      AVL* pivot; //we create a pivot that will help us do a rotation

      int eq_a; 
      int eq_p; 

      pivot         = Tree->pLeft; //the left's son become the pivot
      Tree->pLeft   = pivot->pRight; 
      pivot->pRight = Tree; 

      eq_a       = Tree->eq;
      eq_p       = pivot->eq; 

	//update of equilibrium factors
      Tree->eq  = eq_a - min2(eq_p, 0) + 1; 
      pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1); 
      Tree      = pivot; 

      return Tree; // Tree become the new root
}


// Double left rotation : to equilibrate the AVL Tree that we'll use to sum the consomations...
AVL* DoubleLeftRotation(AVL* Tree){
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again."); //immediate stop if the allocation failed
            exit(60); 
}
      Tree->pRight = RightRotation(Tree->pRight); 
      return LeftRotation(Tree); 
}


// Double right rotation : to equilibrate the AVL Tree that we'll use to sum the consomations...
AVL* DoubleRightRotation(AVL* Tree){
      if(Tree == NULL){
            printf("Error : AVL is NULL. Please try again."); //immediate stop if the allocation failed
            exit(30); 
	}
      Tree->pLeft = LeftRotation(Tree->pLeft); 
      return RightRotation(Tree); 
}



// Function to know what rotation is suitable to the situation of the AVL Tree 
AVL* equilibrageAVL(AVL* Tree){
      if(Tree==NULL){
            printf("Error : AVL is NULL. Please try again."); 
            exit(50); 
      }
      if(Tree->eq >= 2){
	      //case where the tree is unbalanced on the right
            if(Tree->pRight->eq >=0){
                  return LeftRotation(Tree); // simple left rotation
            }
           else{
                  return DoubleLeftRotation(Tree); //double left rotation
                  }
}
      else if(Tree->eq <= -2){
	      //case where the tree is unbalanced on the left
            if(Tree->pLeft->eq <= 0){
                  return RightRotation(Tree); // simple right rotation
            }
            else{
                  return DoubleRightRotation(Tree); // double right rotation 
                  }
      }
      return Tree; 
}


// function to insert new nodes in the AVL and returns the updated AVL 
AVL* insertAVL(AVL* tree, int* h, int id, int capacity, int conso) { // fuite mémoire ici , voir capa et conso mise à jour au meme endroit...

    if (tree == NULL) {
    AVL* New = createNodeAVL(id, capacity, conso); // if the tree is empty, create a new node
    if (New == NULL) {
        printf("The malloc of the new AVL node failed. Please try again.");
        exit(1);
    }
        *h = 1; //the height has increased
        return New;
    }

 
	if (id < tree->station_id) {
		// if the element id is smaller, insert on the left
  	  tree->pLeft = insertAVL(tree->pLeft, h, id, capacity, conso);
    	*h = -(*h);
	} else if (id > tree->station_id) {
		//if the element is is bigger, insert on the right
   	 tree->pRight = insertAVL(tree->pRight, h, id, capacity, conso);
	} else { //element id's already present
  	  tree->sum_conso += conso;
  	  *h = 0;
  	  return tree;
	}


    // update of equilibrium factors 
    if (*h != 0) {
        tree->eq = tree->eq + *h;
        tree = equilibrageAVL(tree);

        if (tree->eq == 0) { //height's update
            *h = 0;
        } else {
            *h = 1; 
        }
    }

    return tree;
}


// Postfix traversal to display and free nodes
void displayAndFree(AVL* tree) {
    if (tree != NULL) {
        displayAndFree(tree->pLeft);   // Process left child
        displayAndFree(tree->pRight);  // Process right child
        // Print current node in "id;capacity;sum_conso" format
        printf("%d:%d:%d\n", tree->station_id, tree->capacity, tree->sum_conso);
        free(tree); // Free memory from children to parents... 
    }
}






