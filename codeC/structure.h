#ifndef STRUCTURES_H
#define STRUCTURES_H

/* Structure AVL : stores the id of the station, its capacity (to transfer energy), the sum of 
consommation of its consummers, plus its child and the value to keep the AVL equilibrated... */ 
typedef struct _AVL{
    int station_id;
    int capacity;
    int sum_conso; 
    int eq; 
    struct _AVL* pLeft; 
    struct _AVL* pRight; 
} AVL; 

#endif
