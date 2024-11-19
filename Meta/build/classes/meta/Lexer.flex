package meta;

import static meta.Tokens.*;
import java.util.HashMap;
import java.util.Map;

%%
%class Lexer
%type Tokens
%unicode

// Definición de patrones
L = [a-zA-Z_]+
D = [0-9]+
espacio = [ \t\r]+
hex = 0[xX][0-9a-fA-F]+
octal = 0[0-7]+
decimal =[0-9]+ 
floatExp = ({D}+"."{D}+([eE][+-]?{D}+)?[fFlL]?)|({D}+([eE][+-]?{D}+)[fFlL]?)|({D}+[eE][+-]?{D}+)
char = '(\\(['""\\bfnrt]|u[0-9A-Fa-f]{4})|[^\\'])'
string = \"([^\\\"]|\\.)*\"
Identificador = [a-zA-Z_]+[a-zA-Z0-9_]*

// Variables de estado y métodos
%{
    public String lexeme;
    public int lineNumber = 1; // Variable para contar el número de líneas
    private Map<String, Map<Integer, Integer>> tokenCountMap = new HashMap<>(); // Mapa para contar tokens por línea
    private boolean insideBlockComment = false;
    private boolean insideString = false; // Nueva bandera para strings no cerrados

    // Método para hacer seguimiento de tokens repetidos en una misma línea 
    private void trackToken(String lexeme) {
        if (!tokenCountMap.containsKey(lexeme)) {
            tokenCountMap.put(lexeme, new HashMap<>());
        }
        Map<Integer, Integer> lineCountMap = tokenCountMap.get(lexeme);
        
        // Incrementamos el conteo para la línea actual
        lineCountMap.put(lineNumber, lineCountMap.getOrDefault(lineNumber, 0) + 1);
    }

%}
%state BLOCK_COMMENT

%%

/* Reglas para palabras reservadas */
"break" { return Break; }
"case" { return Case; }
"char" { return Char; }
"const" { return Const; }
"continue" { return Continue; }
"default" { return Default; }
"do" { return Do; }
"else" { return Else; }
"for" { return For; }
"if" { return If; }
"int" { return Int; }
"long" { return Long; }
"return" { return Return; }
"short" { return Short; }
"switch" { return Switch; }
"void" { return Void; }
"while" { return While; }
"read" { return Read; }
"write" { return Write; }

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
"volatile" { return Reservada; }

/* Ignorar espacios en blanco */
{espacio} { /* Ignorar espacios en blanco */ }

/* Ignorar comentarios de línea solo si no estamos dentro de un string */
"//".* { 
    if (!insideString) {
        // Comentario de línea, ignorar
    } else {
        // Es parte de un string, no hacemos nada
    }
}

/* Ignorar comentarios de bloque solo si no estamos dentro de un string */
"/*" { 
    if (!insideString) {
        yybegin(BLOCK_COMMENT);
    } else {
        // Es parte de un string, no hacemos nada
    }
}

<BLOCK_COMMENT>\n { lineNumber++; }
<BLOCK_COMMENT>[^*]+ { /* Consume todos los caracteres excepto '*' */ }
<BLOCK_COMMENT>\*+([^/]) { /* Consume secuencias de '*' no seguidas por '/' */ }
<BLOCK_COMMENT>"*/" { 
    yybegin(YYINITIAL); 
}

<BLOCK_COMMENT><<EOF>> {
    System.err.println("Error: Comentario de bloque no cerrado en línea " + lineNumber);
    return COMENTARIO_NO_FINALIZADO;
}

/* Reglas para directivas del preprocesador */
"#include"[ \t]+<[^>]+> { 
    lexeme = yytext(); 
    return Preprocesador;
}

"#include"[ \t]+\"[^\"]+\" { 
    lexeme = yytext(); 
    return Preprocesador;
}

"#define"[ \t]+{L}[ \t]+.* { 
    lexeme = yytext(); 
    return Preprocesador;
}

"#ifdef"[ \t]+{L} { 
    lexeme = yytext(); 
    return Preprocesador;
}

"#ifndef"[ \t]+{L} { 
    lexeme = yytext(); 
    return Preprocesador;
}

"#endif" { 
    lexeme = yytext(); 
    return Preprocesador;
}

"#undef"[ \t]+{L} { 
    lexeme = yytext(); 
    return Preprocesador;
}

/* Nueva línea: Aumenta el contador de líneas */
\n { lineNumber++; }

/* Literales (prioridad sobre operadores) */

/* Strings correctamente cerrados, pero que contienen saltos de línea */
\"([^\\\"]|\\.)*\" { 
    lexeme = yytext(); 
    if (lexeme.contains("\n")) {
        System.err.println("Error: String de varias lineas en línea " + lineNumber);
        return STRING_MULTILINEA_CERRADO;
    }
    insideString = false; // El string está cerrado correctamente
    trackToken(lexeme); 
    return Literal;
}

/* Strings no cerrados */
\"([^\\\"]|\\.)* { 
    lexeme = yytext(); 
    System.err.println("Error: String no cerrado en línea " + lineNumber);
    return STRING_NO_CERRADO;
}

/* Caracteres correctamente cerrados */
\'([^\\']|\\.)\' { 
    lexeme = yytext(); 
    trackToken(lexeme); 
    return Literal;
}

/* Caracteres no cerrados */
\'([^\\']|\\.) { 
    lexeme = yytext(); 
    System.err.println("Error: Carácter no cerrado en línea " + lineNumber);
    return CHAR_NO_CERRADO;
}


/* Definición de operadores */
"++" { return Incremento; } 
"--" { return Decremento; } 
"==" { return Igualdad; } 
">=" { return MayorIgual; } 
">" { return Mayor; }
"<=" { return MenorIgual; } 
"<" { return Menor; }
"!=" { return Desigualdad; }
"||" { return Or; }
"&&" { return And; } 
"!" { return Not; } 
"=" { return Asignacion; } 
"+" { return Suma; } 
"-" { return Resta; }
"*" { return Multiplicacion; }
"/" { return Division; } 
"%" { return Modulo; }
"(" { return ParentesisA; } 
")" { return ParentesisC; } 
"{" { return LlaveA; } 
"}" { return LlaveC; } 
"+=" { return AsignacionSuma; }
"-=" { return AsignacionResta; } 
"*=" { return AsignacionMultiplicacion; } 
"/=" { return AsignacionDivision; } 
"," { return Coma; }
";" { return PuntoComa; }

"[" | "]" | ":" | "." | "&" | "^" | "|" | ">>" | "<<" | "~" |
"%=" | "&=" | "^=" | "|=" | "<<=" | ">>=" | "->" | "?" { return Operador; }


/* Identificadores válidos */
{L}({L}|{D})* { 
    lexeme = yytext(); 
    trackToken(lexeme); 
    return Identificador; 
}

/* Identificadores inválidos que contienen caracteres especiales como ñ o letras acentuadas */
([€ƒ„…†‡ŠŒŽ•™šœžŸ¡¢£¤¥¦§©ª­®¯°±²³µ¶¹º¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ])+{L}+([€ƒ„…†‡ŠŒŽ•™šœžŸ¡¢£¤¥¦§©ª­®¯°±²³µ¶¹º¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ])* {
    lexeme = yytext();
    System.err.println("Error: Identificador contiene caracteres no válidos en línea " + lineNumber + ": " + lexeme);
    return IDENTIFICADOR_NO_VALIDO;
}

/* Identificadores inválidos que comienzan con un número */
{D}{L}+ { 
    lexeme = yytext();
    System.err.println("Error: Identificador inválido que comienza con un número en línea " + lineNumber);
    return IDENTIFICADOR_INVALIDO;
}

// Detecta números incompletos que carecen de dígitos antes del punto decimal, como ".5"
"."{D}+ {
    lexeme = yytext();
    System.err.println("Error: Número incompleto (sin dígito antes del punto decimal) en línea " + lineNumber);
    return NUMERO_INCOMPLETO;
}

// Detecta números incompletos que carecen de dígitos después del punto decimal, como "5."
{D}+"." {
    lexeme = yytext();
    System.err.println("Error: Número incompleto (sin dígito después del punto decimal) en línea " + lineNumber);
    return NUMERO_INCOMPLETO;
}

/* Números hexadecimales, octales, decimales y flotantes */
{hex} { return Hexadecimal; }
{octal} { return Octal; }
{decimal} { return Decimal; }
{floatExp} { return Flotante; }

/* Detección de caracteres no permitidos (alfabetos no latinos y ñ) */
[^\\x00-\\x7Fñ] { 
    lexeme = yytext();
    System.err.println("Error: Carácter no definido encontrado en línea " + lineNumber + ": " + yytext());
    return CARACTER_NO_DEFINIDO;
}

/* Error en símbolos no definidos */
. { 
    return CARACTER_NO_DEFINIDO; 
}