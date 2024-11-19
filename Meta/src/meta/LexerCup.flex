package meta;
import java_cup.runtime.Symbol;

%%
%class LexerCup
%type java_cup.runtime.Symbol
%cup
%column
%full
%line
%state BLOCK_COMMENT


// Definición de patrones
L = [a-zA-Z_]+
D = [0-9]+
comasimple =[,]
espacio = [ \t\r\n\f]+
hex = 0[xX][0-9a-fA-F]+
octal = 0[0-7]+
decimal =[0-9]+ 
floatExp = ({D}+"."{D}+([eE][+-]?{D}+)?[fFlL]?)|({D}+([eE][+-]?{D}+)[fFlL]?)|({D}+[eE][+-]?{D}+)
char = '(\\(['""\\bfnrt]|u[0-9A-Fa-f]{4})|[^\\'])'
string = \"([^\\\"]|\\.)*\"
Identificador = [a-zA-Z_]+[a-zA-Z0-9_]*


%{
    private Symbol symbol(int type, Object value){
        return new Symbol(type, yyline, yycolumn, value);
    }

    private Symbol symbol(int type){
        return new Symbol(type, yyline, yycolumn);
    }

%}

%%

/* Reglas para palabras reservadas */
"break" { return new Symbol(sym.Break, yycolumn, yyline, yytext()); }
"case" { return new Symbol(sym.Case, yycolumn, yyline, yytext()); }
"char" { return new Symbol(sym.Char, yycolumn, yyline, yytext()); }
"const" { return new Symbol(sym.Const, yycolumn, yyline, yytext()); }
"continue" { return new Symbol(sym.Continue, yycolumn, yyline, yytext()); }
"default" { return new Symbol(sym.Default, yycolumn, yyline, yytext());}
"do" { return new Symbol(sym.Do, yycolumn, yyline, yytext());}
"else" { return new Symbol(sym.Else, yycolumn, yyline, yytext()); }
"for" { return new Symbol(sym.For, yycolumn, yyline, yytext());}
"if" { return new Symbol(sym.If, yycolumn, yyline, yytext());}
"int" { return new Symbol(sym.Int, yycolumn, yyline, yytext()); }
"long" { return new Symbol(sym.Long, yycolumn, yyline, yytext()); }
"return" { return new Symbol(sym.Return, yycolumn, yyline, yytext()); }
"short" { return new Symbol(sym.Short, yycolumn, yyline, yytext()); }
"switch" { return new Symbol(sym.Switch, yycolumn, yyline, yytext());}
"void" { return new Symbol(sym.Void, yycolumn, yyline, yytext()); }
"while" { return new Symbol(sym.While, yycolumn, yyline, yytext()); }
"write" { return new Symbol(sym.Write, yycolumn, yyline, yytext()); }
"read" { return new Symbol(sym.Read, yycolumn, yyline, yytext()); }

"auto" |
"double" |
"enum" |
"extern" |
"float" |
"goto" |
"register" |
"signed" |
"sizeof" |
"static" |
"struct" |
"typedef" |
"union" |
"unsigned" |
"volatile" { return new Symbol(sym.Reservada, yycolumn, yyline, yytext()); }

/* Ignorar espacios en blanco */
{espacio} { /* Ignorar espacios en blanco */ }

/* Ignorar comentarios de línea solo si no estamos dentro de un string */
"//".* { /* Ignorar comentario de línea */ }

/* Ignorar comentarios de bloque solo si no estamos dentro de un string */
"/*"  { yybegin(BLOCK_COMMENT); }

<BLOCK_COMMENT>\n { /*Ignorar nueva linea*/ }
<BLOCK_COMMENT>[^*]+ { /* Consume todos los caracteres excepto '*' */ }
<BLOCK_COMMENT>\*+([^/]) { /* Consume secuencias de '*' no seguidas por '/' */ }
<BLOCK_COMMENT>"*/" { yybegin(YYINITIAL); }

<BLOCK_COMMENT><<EOF>> {
    System.err.println("Error: Comentario de bloque no cerrado en línea " + yyline);
    return new Symbol(sym.COMENTARIO_NO_FINALIZADO, yycolumn, yyline, yytext());
}

/* Reglas para directivas del preprocesador */
"#include"[ \t]+<[^>]+> { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }
"#include"[ \t]+\"[^\"]+\" { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }
"#define"[ \t]+{L}[ \t]+.* { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }
"#ifdef"[ \t]+{L} { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }
"#ifndef"[ \t]+{L} { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }
"#endif" { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }
"#undef"[ \t]+{L} { return new Symbol(sym.Preprocesador, yycolumn, yyline, yytext()); }

/* Strings */
\"([^\\\"]|\\.)*\" { return new Symbol(sym.Literal, yycolumn, yyline, yytext()); }
\"([^\\\"]|\\.)* { System.err.println("Error: String no cerrado en línea " + yyline); return new Symbol(sym.STRING_NO_CERRADO, yycolumn, yyline, yytext()); }

/* Caracteres */
\'([^\\']|\\.)\' { return new Symbol(sym.Literal, yycolumn, yyline, yytext()); }
\'([^\\']|\\.) { System.err.println("Error: Carácter no cerrado en línea " + yyline); return new Symbol(sym.CHAR_NO_CERRADO, yycolumn, yyline, yytext()); }

/* Definición de operadores */
"++" { return new Symbol(sym.Incremento, yycolumn, yyline, yytext());} 
"--" { return new Symbol(sym.Decremento, yycolumn, yyline, yytext()); } 
"==" { return new Symbol(sym.Igualdad, yycolumn, yyline, yytext()); } 
">=" { return new Symbol(sym.MayorIgual, yycolumn, yyline, yytext()); } 
">" { return new Symbol(sym.Mayor, yycolumn, yyline, yytext()); }
"<=" { return new Symbol(sym.MenorIgual, yycolumn, yyline, yytext()); } 
"<" { return new Symbol(sym.Menor, yycolumn, yyline, yytext()); }
"!=" { return new Symbol(sym.Desigualdad, yycolumn, yyline, yytext()); }
"||" { return new Symbol(sym.Or, yycolumn, yyline, yytext()); }
"&&" { return new Symbol(sym.And, yycolumn, yyline, yytext()); } 
"!" { return new Symbol(sym.Not, yycolumn, yyline, yytext()); } 
"=" { return new Symbol(sym.Asignacion, yycolumn, yyline, yytext()); } 
"+" { return new Symbol(sym.Suma, yycolumn, yyline, yytext()); } 
"-" { return new Symbol(sym.Resta, yycolumn, yyline, yytext()); }
"*" { return new Symbol(sym.Multiplicacion, yycolumn, yyline, yytext()); }
"/" { return new Symbol(sym.Division, yycolumn, yyline, yytext()); } 
"%" { return new Symbol(sym.Modulo, yycolumn, yyline, yytext()); }
"(" { return new Symbol(sym.ParentesisA, yycolumn, yyline, yytext()); } 
")" { return new Symbol(sym.ParentesisC, yycolumn, yyline, yytext()); } 
"{" { return new Symbol(sym.LlaveA, yycolumn, yyline, yytext()); } 
"}" { return new Symbol(sym.LlaveC, yycolumn, yyline, yytext()); } 
"+=" { return new Symbol(sym.AsignacionSuma, yycolumn, yyline, yytext()); }
"-=" { return new Symbol(sym.AsignacionResta, yycolumn, yyline, yytext()); } 
"*=" { return new Symbol(sym.AsignacionMultiplicacion, yycolumn, yyline, yytext()); } 
"/=" { return new Symbol(sym.AsignacionDivision, yycolumn, yyline, yytext()); } 
"," { return new Symbol(sym.ComaSimple, yycolumn, yyline, yytext()); }
";" { return new Symbol(sym.PuntoComa, yycolumn, yyline, yytext()); }
":" { return new Symbol(sym.DosPuntos, yycolumn, yyline, yytext()); }

"[" | "]" | ":" | "." | "&" | "^" | "|" | ">>" | "<<" | "~" |
"%=" | "&=" | "^=" | "|=" | "<<=" | ">>=" | "->" | "?" { return new Symbol(sym.Operador, yycolumn, yyline, yytext()); }

/* Identificadores válidos */
{L}({L}|{D})* { 
    return new Symbol(sym.Identificador, yycolumn, yyline, yytext());
}

/* Identificadores inválidos que contienen caracteres especiales como ñ o letras acentuadas */
([€ƒ„…†‡ŠŒŽ•™šœžŸ¡¢£¤¥¦§©ª­®¯°±²³µ¶¹º¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ])+{L}+([€ƒ„…†‡ŠŒŽ•™šœžŸ¡¢£¤¥¦§©ª­®¯°±²³µ¶¹º¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ])* {
    System.err.println("Error: Identificador contiene caracteres no válidos en línea " + yyline);
    return new Symbol(sym.IDENTIFICADOR_NO_VALIDO, yycolumn, yyline, yytext());
}

/* Identificadores inválidos que comienzan con un número */
{D}{L}+ { 
    System.err.println("Error: Identificador inválido que comienza con un número en línea " + yyline);
    return new Symbol(sym.IDENTIFICADOR_INVALIDO, yycolumn, yyline, yytext());
}

// Detecta números incompletos que carecen de dígitos antes del punto decimal, como ".5"
"."{D}+ {
    System.err.println("Error: Número incompleto (sin dígito antes del punto decimal) en línea " + yyline);
    return new Symbol(sym.NUMERO_INCOMPLETO, yycolumn, yyline, yytext());
}

// Detecta números incompletos que carecen de dígitos después del punto decimal, como "5."
{D}+"." {
    System.err.println("Error: Número incompleto (sin dígito después del punto decimal) en línea " + yyline);
    return new Symbol(sym.NUMERO_INCOMPLETO, yycolumn, yyline, yytext());
}


/* Números hexadecimales, octales, decimales y flotantes */
{hex} { return new Symbol(sym.Hexadecimal, yycolumn, yyline, yytext()); }
{octal} { return new Symbol(sym.Octal, yycolumn, yyline, yytext()); }
{decimal} { return new Symbol(sym.Decimal, yycolumn, yyline, yytext()); }
{floatExp} { return new Symbol(sym.Flotante, yycolumn, yyline, yytext()); }

/* Errores */
[^\\x00-\\x7Fñ] { System.err.println("Error: Carácter no definido encontrado en línea " + yyline + ": " + yytext()); return new Symbol(sym.CARACTER_NO_DEFINIDO, yycolumn, yyline, yytext()); }

. { System.err.println("Error: Carácter no definido en línea " + yyline + ": " + yytext()); return new Symbol(sym.CARACTER_NO_DEFINIDO, yycolumn, yyline, yytext()); }