// ici continuer les fonctions et ajouter des commentaires en anglais 


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


// needed HERE : function max and min (to equilibrate the tree !! (à comprendre aussi)
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

// ajouter des commentaires pour les rotations pour mieux comprendre aussi !!

// function that do a simple left rotation in the tree to help us keep it equilibrated 
AVL* LeftRotation(AVL* Tree){
      if(Tree == NULL)
        printf("AVL null... Please try again.");
        exit(2);

      AVL* pivot; // we create a pivot that will help us do a rotation 
      if(pivot == NULL)
        printf("Error : creation of a pivot for a LeftRotation failed. Please try again")
          exit(3); 

      int eq1; 
      int eq2; 

      pivot        = Tree->pRight; 
      Tree->pRight = pivot->pLeft; 
      pivot->pLeft = Tree; 

      eq1 = Tree->eq; 
      eq2 = pivot->eq; 
  
      Tree->eq  = eq1 - max2(eq2,0) - 1; 
      pivot->eq = min3(eq1 - 2, eq1 + eq2 - 2, eq1 - 1); 
      Tree      = pivot; 

      return Tree;
}


AVL* RightRotation(AVL* Tree){ // à faire comme celle d'avant 
      if(Tree == NULL)
            printf("Error : AVL is NULL. Please try again.");
            exit(2); 
      }

      AVL* pivot; // voir ici si je le crée ou je laisse comme ca... mais du coup la verif d'après n'a pas de sens..?
      if(pivot == NULL)
            printf("Error : pivot is null."); 
            exit(3); 
      }

      int eq1; 
      int eq2; 

      pivot         = Tree->pLeft;
      Tree->pleft   = pivot->pRight; 
      pivot->pRight = Tree; 

      eq1       = Tree->eq;
      eq2       = pivot->eq; 

      Tree->eq  = eq1 - min2(eq2, 0) + 1; 
      pivot->eq = max3(eq1 + 2, eq1 + eq2 + 2, eq2 + 1); 
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
      if(Tree->eq > 1){
            if(Tree->pRight->eq >=0){
                  return leftRotation(Tree)
            }
           else{
                  return DoubleLeftRotation(Tree); 
                  }
}
      else if(Tree->eq < -1){
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
AVL insertAVL(AVL* Tree, int* h, int id, int capacity, int conso){

      AVL* New = createNodeAVL(id, capacity, conso); 
      if(New == NULL){
            printf("The malloc of the new AVL node failed. Please try again."); 
            exit(); 
      }
      if(Tree == NULL){
            *h = 1; 
            return New; 
      }
      else if(New->id <= Tree->id){ // regarder pour le = si il est nécéssaire et comprendre les h...
            Tree->pLeft = insertAVL(Tree->pLeft, h, id, capacity, conso); 
            *h = -(*h); 
      }
      else if(New->id > Tree->id){
            Tree->pLeft = insertAVL(Tree->pRight, h, id, capacity, conso); 
      }
      else{
            h=0; 
            return Tree; 
      }
      if(h != 0){
            Tree->eq = Tree->eq + *h; 
            Tree = equilibrageAVL(Tree); 
      }
            if(Tree->eq == 0){
                  *h = 0; 
            }
            else{
                  *h = 1; 
            }

      return Tree; 
}



// once the AVL is full and equilibrated, we'll sum up all the consumtions of energy
// we'll do it with a recursive function for each node... 
int sum_conso(AVL* Tree){
      if(Tree==NULL)
            printf("Error : AVL is NULL. Please try again.") 
            exit(.);


// voir si on commence par le bas ou par le haut 
// adapter la suppression des noeuds en fonction de ce choix...

void postfixDisplay // voir ou mettre ca : il faut lire les enfants lors de la somme de conso et les supprimer peu à peu 
// en tout cas c'est l'idée... à voir 
// jsp pour cette fonction. On en a pas trop besoin finalement 




