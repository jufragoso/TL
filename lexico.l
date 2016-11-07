%{
#include "expresiones.h"
#include <math.h>
#include <string.h>
int n_lineas;
%}
%x COM
%option noyywrap
 
%%

[#] 	BEGIN(COM);
<COM>[\n] BEGIN(0);
<COM>.		  ;

[t][e][m][p][e][r][a][t][u][r][a]       return TEMPERATURA;
[l][u][m][i][n][o][s][i][d][a][d]       return LUMINOSIDAD;
[h][u][m][o]				return HUMO;
[a][l][a][r][m][a]			return ALARMA;
[l][u][z]				return LUZ;
[a][c][t][i][v][a][r]			return ACTIVAR;
[d][e][s][a][c][t][i][v][a][r]		return DESACTIVAR;
[r][e][a][l]				return VAR_REAL;
[e][n][t][e][r][o]			return VAR_ENTERO;
[p][o][s][i][c][i][o][n]		return VAR_POSICION;
[e][s][c][r][i][b][i][r]		return ESCRIBIR;
[p][l][a][n][o]				return PLANO;
[s][e][n][s][o][r]			return SENSOR;
[a][c][t][u][a][d][o][r]		return ACTUADOR;
[p][a][u][s][a]				return PAUSA;
[Ss][Aa][Ll][Ii][Rr]			return SALIR;
[%][%]					return DELIMITADOR;
[0-9]+					yylval.c_entero = atoi(yytext);return NUMERO;
[0-9]+[.][0-9]+				yylval.c_real = atof(yytext);return REAL;
[A-Za-zÑñ_][A-Za-zÑñ_0-9]*		strcpy(yylval.c_cadena,yytext);return IDENTIFICADOR;		
\n					n_lineas++; return (yytext[0]);
[<][=]					return MENOR_IGUAL;
[>][=]					return MAYOR_IGUAL;
[=][=]					return IGUAL;
[!][=]					return DISTINTO;
[&][&]					return AND;
[|][|]					return OR;
[\t ]					;
. 					return (yytext[0]);
%%
