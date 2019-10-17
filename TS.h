#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct simbolo{
	char *nombre; // Nombre del identificador
	struct simbolo *siguiente_nodo;
};

typedef struct simbolo simbolo;
simbolo *tabla_simbolos = (simbolo *)0;

simbolo *inserta_simbolo(char *nombre_simbolo){
	simbolo *ptr;
	ptr = (simbolo *)malloc(sizeof(simbolo));
	ptr -> nombre = (char *)malloc(strlen(nombre_simbolo)+1);
	strcpy(ptr->nombre, nombre_simbolo);
	ptr -> siguiente_nodo = (struct simbolo *)tabla_simbolos;
	tabla_simbolos = ptr;
	return ptr;
}

simbolo *obtener_simbolo(char *nombre_simbolo){
	simbolo *ptr;
	for(ptr = tabla_simbolos; ptr != (simbolo *)0; ptr = (simbolo *)ptr->siguiente_nodo)
		if(strcmp(ptr -> nombre, nombre_simbolo) == 0)
			return ptr;
	return 0;
}

void imprime_tabla(simbolo *primer_simbolo){
	simbolo *simbolo_actual = primer_simbolo;
	while(simbolo_actual != NULL){  /*ptr != (simbolo *)0*/
		printf("%s \n",simbolo_actual -> nombre);
		simbolo_actual = simbolo_actual -> siguiente_nodo;
	}
}