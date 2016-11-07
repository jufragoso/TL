
%{

#include <iostream>
#include <string.h>
#include <cmath>
#include "Tabla_Simbolos.h"

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;
extern int yylex();

bool esReal =false;
bool errorSemantico =false;
//bool errorSemantico_Variable = false;
bool no_variable = false;
bool op_logica = false;
Tabla_Simbolos t;
tipo_dato var;
tipo_cadena nombre;
tipo_cadena nombre_error;
//definición de procedimientos auxiliares
void prompt(){
  	cout << "LISTO> ";
}

void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
	cout << "Error sintáctico en la línea "<< n_lineas<<endl;
	prompt();
} 

void valorBooleano (bool valor){
	if(valor ==1){
		cout << "verdadero";
	}else{
		cout << "falso";
	}
}

void tipoOperacion(){
	if(esReal){
		cout <<"real";
	}else{
		cout << "entero";
	}
}

void mostrarAritmetica(char* variable, float resultado){
	
	if(no_variable){
		cout << "Error semántico en la línea " <<n_lineas <<". La variable " << nombre_error << " no ha sido definida." << endl;

	}else if(errorSemantico){
		cout << "Error semántico en la línea " << n_lineas << ": el operador % no se puede usar con datos de tipo real" << endl;
	}else if(op_logica){
		cout << "Error semántico en la línea " << n_lineas << ". No se pueden hacer operaciones aritméticas con variables de tipo lógico." << endl;
	}else{
		if(!esReal){
			cout << "La instrucción "<<n_lineas<< " hace que la variable " << variable << ", de tipo ";
			tipoOperacion(); 
			cout<< ", tome el valor " << (int)resultado << endl; 
			
		}else{
			cout << "La instrucción "<<n_lineas<< " hace que la variable " << variable << ", de tipo ";
			tipoOperacion(); 
			cout<< ", tome el valor " << resultado << endl; 
			
		}
		
	} 
	op_logica = false;
	//errorSemantico_Variable = false;
	no_variable = false;
	errorSemantico=false;
	esReal =false; 
	prompt();
}

void mostrarLogica(char* variable, bool resultado){
	if(no_variable){
		cout << "Error semántico en la línea "<< n_lineas <<". La variable " << nombre_error << " no ha sido definida" << endl;
	}else{
		cout << "La instrucción "<<n_lineas<< " hace que la variable " << variable << ", de tipo lógico, tome el valor ";
		valorBooleano(resultado); 
		cout<< endl; 
	}
	no_variable = false;
	errorSemantico=false;
	esReal =false; 
	prompt();
}


void crearVariable(float valor){
	if(!esReal){
		var.tipo=0;
		var.valor.valor_entero = (int) valor;
	}else{
		var.tipo =1;
		var.valor.valor_real = valor;
	}
}

bool comprobarPosicionInicial(int p){
	if(p1>0){
		return false;
	}
	
	return true;
}



%}

%union{
	int c_entero;
	float c_real;
	char c_cadena[20];
	bool c_logico;
}

%start entrada
%token <c_entero> NUMERO 
%token <c_real> REAL
%token <c_cadena> IDENTIFICADOR
%token MENOR_IGUAL MAYOR_IGUAL IGUAL DISTINTO AND OR
%token SALIR

%type <c_real> expr
%type <c_logico> log

%left '+' '-'   /* asociativo por la izquierda, misma prioridad */
%left '*' '/' '%'   /* asociativo por la izquierda, prioridad alta */
%right '^'	/* asociativo por la derecga, prioridad mas alta */
%left menosUnario
%left op_or
%left op_and
%left '!'
 

%%
programa: zona1 DELIMITADOR zona2 DELIMITADOR zona3;

reglas_zona1: plano
	    | reglas_zona1 sensor
	    | reglas_zona1 actuador
	    | reglas_zona1 variables
	    ;

zona1: reglas_zona1;
     

     
plano: PLANO '=' '{' posicion ',' posicion ',' posicion ',' posicion '}' ';'
	{if(!comprobarPosicionInicial($4)) cout<< "ERROR: La posición inicial del plano no es correcta" << endl;};

posicion: '<' expr ',' expr '>' {$$=$2+$4;};

sensor: SENSOR IDENTIFICADOR TEMPERATURA posicion ';'
      | SENSOR IDENTIFICADOR HUMO posicion ';'
      | SENSOR IDENTIFICADOR LUMINOSIDAD posicion ';'
      ;
      
actuador: ACTUADOR IDENTIFICADOR ALARMA posicion ';'
	| ACTUADOR IDENTIFICADOR LUZ posicion ';'
	;
	
lista_enteros: IDENTIFICADOR 
	     | lista_enteros ',' IDENTIFICADOR
	     ;
	     
lista_reales: IDENTIFICADOR 
	     | lista_reales ',' IDENTIFICADOR
	     ;
	     
lista_posicion: IDENTIFICADOR 
	     | lista_posicion ',' IDENTIFICADOR
	     ;

	
variables: VAR_ENTERO lista_enteros '=' expr ';' {if(esReal) cout << "ERROR: No se puede asignar a una variable entera valores reales" << endl;}
         | VAR_REAL lista_reales '=' expr;' {if(!esReal) cout << "ERROR: No se puede asignar a una variable real valores enteros" << endl;}
         | VAR_POSICION lista_posicion '=' posicion ';'
         ;





linea: 	IDENTIFICADOR '=' expr '\n' {strcpy(var.nombre,$1);if(!no_variable && !errorSemantico && !op_logica){
					crearVariable($3);
					if(t.insertar(n_lineas,var)){
						mostrarAritmetica($1,$3);
					}else{
						op_logica = false;
						no_variable = false;
						errorSemantico=false;
						esReal =false; 
						prompt();
							
					}	
				    }else{
				    	mostrarAritmetica($1,$3);
				    }}
	|IDENTIFICADOR '=' log '\n' {strcpy(var.nombre,$1);if(!no_variable && !errorSemantico){
					var.tipo=2;
					var.valor.valor_logico=$3;
					if(t.insertar(n_lineas,var)){
						mostrarLogica($1,$3);
					}else{
						no_variable = false;
						errorSemantico=false;
						esReal =false; 
						prompt();
					}	
				    }else{
				    	mostrarLogica($1,$3);
				    }}
	| error '\n'    {yyerrok;}
	|SALIR 	'\n'			{t.mostrar(); return(0);	}         
	;

expr:    NUMERO 		{$$=$1;}
       |REAL                    {esReal = true; $$=$1;} 
       |IDENTIFICADOR 		{strcpy(nombre,$1);if(t.buscar(nombre, var)){
       					if(var.tipo==0){
       					$$=var.valor.valor_entero;
       					}else if(var.tipo==1){
       					esReal=true;
       					$$ =var.valor.valor_real;
       					}else {
       						op_logica = true;
       					}
       				}else{
       					strcpy(nombre_error, nombre);
       					no_variable=true;
       				}
       
       				} 
       | expr '+' expr 		{$$=$1+$3;}              
       | expr '-' expr    	{$$=$1-$3;}            
       | expr '*' expr          {$$=$1*$3;} 
       | expr '/' expr          {if(esReal){
       					$$=$1/$3;
       				}else{
       					$$=trunc($1/$3);
       				}} 
       | '(' expr ')'		{$$=$2;}
       | expr '^' expr 		{$$=pow($1,$3);}
       | expr '%' expr 		{ $$=(int)$1%(int)$3; if(trunc($1)<$1 || trunc($3) < $3){ errorSemantico=true;}}
       | '-' expr  %prec menosUnario 		{$$=-$2;}
       ;
      
log : expr '<' expr 		{$$=$1<$3;}
      | expr MENOR_IGUAL expr 	{$$=$1<=$3;}
      | expr '>' expr 		{$$ = $1>$3;}
      | expr MAYOR_IGUAL expr 	{$$= $1>=$3;}
      | expr IGUAL expr 	{$$= $1==$3;}
      | expr DISTINTO expr 	{$$= $1!=$3;}
      | log AND log 	%prec op_and 	{$$ = $1 && $3;}
      | log OR log 	%prec op_or	{$$=$1||$3;}
      | '!' log  		{$$=!$2;}
      | '(' log ')' 	 	{$$=$2;}
      ;
	
%%

int main(){
     
     n_lineas = 0;
     
     cout <<endl<<"******************************************************"<<endl;
     cout <<"*      Calculadora de expresiones aritméticas        *"<<endl;
     cout <<"*                                                    *"<<endl;
     cout <<"*      1)con el prompt LISTO>                        *"<<endl;
     cout <<"*        teclea una expresión, por ej. 1+2<ENTER>    *"<<endl;
     cout <<"*        Este programa indicará                      *"<<endl;
     cout <<"*        si es gramaticalmente correcto              *"<<endl;
     cout <<"*      2)para terminar el programa                   *"<<endl;
     cout <<"*        teclear SALIR<ENTER>                        *"<<endl;
     cout <<"*      3)si se comete algun error en la expresión    *"<<endl;
     cout <<"*        se mostrará un mensaje                      *"<<endl;
     cout <<"******************************************************"<<endl<<endl<<endl;
     yyparse();
     cout <<"****************************************************"<<endl;
     cout <<"*                                                  *"<<endl;
     cout <<"*                 ADIOS!!!!                        *"<<endl;
     cout <<"****************************************************"<<endl;
     return 0;
}







