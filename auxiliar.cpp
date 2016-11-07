#include <iostream>
#include <string.h>
#include <cmath>
#include "Tabla_Simbolos.h"

void insertarEntero(int n_lineas, char nombre[20], Tabla_Simbolos &tabla){
	tipo_dato aux;
	strcpy(aux.nombre, nombre);
	aux.tipo = 0;
	aux.valor.valor_entero=0;
	tabla.insertar(n_lineas, aux);
}


void insertarReal(int n_lineas, char nombre[20], Tabla_Simbolos &tabla){
	tipo_dato aux;
	strcpy(aux.nombre, nombre);
	aux.tipo = 1;
	aux.valor.valor_real=0;
	tabla.insertar(n_lineas, aux);
}

/*
void insertarLogico(int n_lineas, char nombre[20], Tabla_Simbolos &tabla){
	tipo_dato aux;
	strcpy(aux.nombre, nombre);
	aux.tipo = 2;
	aux.valor.valor_logico=false;
	tabla.insertar(n_lineas, aux);
}
*/
void insertarPosicion(int n_lineas, char nombre[20], Tabla_Simbolos &tabla){
	tipo_dato aux;
	strcpy(aux.nombre, nombre);
	aux.tipo = 3;
	aux.valor.valor_pos[0]=0;
	aux.valor.valor_pos[1]=0;
	tabla.insertar(n_lineas, aux);
}

void asignarExprEnteraReal(char nombre[20], float valor, Tabla_Simbolos &tabla){
	tipo_dato variable;
	if(t.buscar(nombre, variable)){
		if(variable.tipo==0){
			variable.valor.valor_entero = (int)valor;
			t.insertar(variable);
		}else if(variable.tipo==1){
			variable.valor.valor_real = valor;
			t.insertar(variable);
		}else{
			cout << "ERROR. No se puede asignar una variable posición a una variable de tipo entero o real." << endl;
		}
	}else{
		cout << "ERROR. La variable no existe." << endl;
	}
}

void asignarExprEnteraReal(char nombre[20], int valor1, int valor2, Tabla_Simbolos &tabla){
	tipo_dato variable;
	if(t.buscar(nombre, variable)){
		if(variable.tipo==3){
			variable.valor.valor_pos[0] = valor1;
			variable.valor.valor_pos[1] = valor2;
			t.insertar(variable);
		}else{
			cout << "ERROR. No se puede asignar una variable entera o real a una variable posición." << endl;
		}
	}else{
		cout << "ERROR. La variable no existe." << endl;
	}
}

void valorBooleano (bool valor){
	if(valor ==1){
		cout << "verdadero";
	}else{
		cout << "falso";
	}
}
