#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Structure AVL : stores the id of the station, its capacity (to transfer energy), the sum of 
consommation of its consummers, plus its child... */ 
typedef struct _AVL{
    char* station_id;
    int capacity;
    int sum_conso; 
    struct _AVL* pLeft; 
    struct _AVL* pRight;
    
} AVL; 



// penser à transformer tous les - par des 0 : prof's idea. 
