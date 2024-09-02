package codigo;
import static codigo.Tokens.*;
%%
%class Lexer
%type Tokens
L=[a-zA-Z_]+
D=[0-9]+
espacio=[ \t\r\n]+
hex="0[xX][0-9a-fA-F]+([uU][lL]?[lL]?|[lL][uU]?[lL]?)?" 
octal="0[0-7]+([uU][lL]?[lL]?|[lL][uU]?[lL]?)?" 
decimal={D}+([uU][lL]?[lL]?|[lL][uU]?[lL]?)? 
floatExp=({D}+"."{D}+([eE][+-]?{D}+)?[fFlL]?)|({D}+([eE][+-]?{D}+)[fFlL]?) 
char="\'([^\\\']|\\[ntrbf\'\"\\])\'|#[0-9]+" 
string="\"([^\\\"]|\\[ntrbf\'\"\\])*\"" 

%{
    public String lexeme;
%}
%%

"auto" |
"break" |
"case" |
"char" |
"const" |
"continue" |
"default" |
"do" |
"double" |
"else" |
"enum" |
"extern" |
"float" |
"for" |
"goto" |
"if" |
"int" |
"long" |
"register" |
"return" |
"short" |
"signed" |
"sizeof" |
"static" |
"struct" |
"switch" |
"typedef" |
"union" |
"unsigned" |
"void" |
"volatile" |
"while" {lexeme=yytext(); return Reservada;}

{espacio} {/*Ignorar espacios en blanco*/}

"//".* {/*Ignorar comentarios de línea*/}

"/*"([^*]|[\r\n]|"*"[^/])*"*/" {/*Ignorar comentarios de bloque*/}

"++" | "--" | "==" | ">=" | ">" | "<=" | "<" | "!=" |
"||" | "&&" | "!" | "=" | "+" | "-" | "*" | "/" | "%" |
"(" | ")" | "[" | "]" | "{" | "}" | ":" | "." | "+=" |
"-=" | "*=" | "/=" | "&" | "^" | "|" | ">>" | "<<" | "~" |
"%=" | "&=" | "^=" | "|=" | "<<=" | ">>=" | "->" | "," | ";" |
"?" {lexeme=yytext(); return Operador;}

{L}({L}|{D})* {lexeme=yytext(); return Identificador;}

{hex} |
{octal} |
{decimal} |
{floatExp} {lexeme=yytext(); return Literal;} 

{char} {lexeme=yytext(); return Literal;} 

{string} {lexeme=yytext(); return Literal;} 

. {return ERROR;}

