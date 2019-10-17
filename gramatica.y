%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "TS.h"

#define YYDEBUG 1
int errores;

int yylex();
int yyerror(const char *s);


/*
Verifica si el identificador que se pasa como
parametro ya esta en la tabla de simbols.
Si ya existe, manda error e incrementa el número de errores
si no existe entonces lo inserta en la tabla de simbolos.
Se usa en las reglas de declaraciones
entero a; <-  tendría que insertarla en la tabla de simbolos
entero a; <-- tendría que marcar que ya está
*/
void instalar(char *nombre_simbolo){
	simbolo *s;
	s = obtener_simbolo(nombre_simbolo);
	if( s == 0 )
		s = inserta_simbolo(nombre_simbolo);
	else{
		errores++;
		printf("(Variable duplicada): %s ya está declarada \n",nombre_simbolo);
	}
}

/*
Si la variable no está declarada anteriormente
entonces no se puede usar y manda un mensaje
Se utiliza en cualquier expresion o funcion
que utilice una variable
leer(edad); <- Si no existe en la tabla manda error
								porque se debe declarar antes
						<- Si ya existe no hace nada porque ya
								está declarada
*/
void verifica_contexto(char *nombre_simbolo){
	if(obtener_simbolo(nombre_simbolo) == 0){
		printf("%s es un identificador no declarado \n",nombre_simbolo);
		errores++;
	}
}







%}
/* Valores semánticos de los tokens */
%union{
	char *cadena;
	int entero;
}


%start programa
%token ENTERO
%token CADENA
%token <cadena> IDENTIFICADOR
%token <entero> NUMERO
%token ABRIR_BLOQUE CERRAR_BLOQUE
%token PRINCIPAL
%token LEER IMPRIMIR MIENTRAS PARA
%token OR ASIGNACION DOBLE_MAS DOBLE_MENOS MAS

%left '<' OR MAS
%right DOBLE_MAS  DOBLE_MENOS


%%

programa : PRINCIPAL '(' ')' ABRIR_BLOQUE
		  declaraciones
		  instrucciones
          CERRAR_BLOQUE
          ;



declaraciones : /*declaraciones*/
		| declaraciones declaracion ';'
		;

declaracion : /*empty*/
		|  ENTERO IDENTIFICADOR 		{ instalar($2); }
		;


instrucciones : /*empty*/
		| instrucciones instruccion ';'
		;

instruccion : LEER '(' IDENTIFICADOR ')'    { verifica_contexto($3);  }
		| IDENTIFICADOR ASIGNACION expresion_aritmetica
		| IMPRIMIR '(' CADENA ')'
		| MIENTRAS '(' expresion ')' ABRIR_BLOQUE
			instrucciones
		  CERRAR_BLOQUE
		| PARA '(' IDENTIFICADOR ASIGNACION NUMERO ';' expresion ';' expresion_incremento  ')' ABRIR_BLOQUE
			instrucciones
			CERRAR_BLOQUE
		;


expresion : expresion '<' expresion
		|   expresion OR expresion
		| NUMERO
		| IDENTIFICADOR            { verifica_contexto($1);  }
		| expresion_incremento
		| expresion_aritmetica
		;


expresion_incremento : IDENTIFICADOR DOBLE_MAS
										 | IDENTIFICADOR DOBLE_MENOS
										 ;

expresion_aritmetica : expresion_aritmetica MAS expresion_aritmetica
										 | NUMERO
										 | IDENTIFICADOR
										 | '(' expresion_aritmetica ')'
										 ;

%%

#include "lex.yy.c"

int main(){
    yyparse();
}

int yyerror(const char *s){
  fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,s);
}
