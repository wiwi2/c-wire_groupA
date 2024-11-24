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
max2 : finds the max between two values 
max3 : finds the max between three values 
min2 : finds the min between two values 
min3 : finds the min between three values 


AVL* LeftRotation(AVL* Tree){
      if(Tree == NULL)
        printf("AVL null... Please try again.");
        exit(2);

      AVL* pivot; 
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

AVL* DoubleLeftRotation 

AVL* DoubleRightRotation 


AVL insertAVL 


void postfixDisplay // voir ou mettre ca : il faut lire les enfants lors de la somme de conso et les supprimer peu à peu 
// en tout cas c'est l'idée... à voir 





