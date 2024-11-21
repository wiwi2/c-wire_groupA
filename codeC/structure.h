#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Structure AVL : stores the id of the station, its capacity (to transfer energy), the sum of 
consommation of its consummers, plus its child and the value to keep the AVL equilibré... */ 
typedef struct _AVL{
    int station_id;
    int capacity;
    int sum_conso; 
    int eq; 
    struct _AVL* pLeft; 
    struct _AVL* pRight; 
} AVL; 



// penser à transformer tous les - par des 0 : prof's idea. 
