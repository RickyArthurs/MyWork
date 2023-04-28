//////////////////////////////////////////////////////////////
//
// Specification of the Fun grammar.
//
// Development of for and switch procedures
//
// Richard Arthurs - 2465714A - 19/03/2022
//
//////////////////////////////////////////////////////////////


grammar Fun;

// This specifies the Fun grammar, defining the syntax of Fun.

@header{
	package ast;
}

//////// Programs

program
	:	var_decl* proc_decl+ EOF  # prog
	;


//////// Declarations

proc_decl
	:	PROC ID
		  LPAR formal_decl RPAR COLON
		  var_decl* seq_com DOT   # proc

	|	FUNC type ID
		  LPAR formal_decl RPAR COLON
		  var_decl* seq_com
		  RETURN expr DOT         # func
	;

formal_decl
	:	(type ID)?                # formal
	;

var_decl
	:	type ID ASSN expr         # var
	;

type
	:	BOOL                      # bool
	|	INT                       # int
	;


//////// Commands

com
	:	ID ASSN expr              # assn
	|	ID LPAR actual RPAR       # proccall
							 
	|	IF expr COLON c1=seq_com
		  ( DOT              
		  | ELSE COLON c2=seq_com DOT   
		  )                       # if

	|	WHILE expr COLON          
		  seq_com DOT             # while

// EXTENSION
	|	FOR ID ASSN e1=expr TO e2=expr COLON
		 seq_com DOT 							#forloop
		 
		 
	|	SWITCH expr COLON
	   (CASE guard COLON c1=seq_com)*
	   DEFAULT COLON c2=seq_com DOT			# switch
	;
// EXTENSION ENDS

seq_com
	:	com*                      # seq
	;


//////// Expressions

expr
	:	e1=sec_expr
		  ( op=(EQ | LT | GT) e2=sec_expr )?
	;

sec_expr
	:	e1=prim_expr
		  ( op=(PLUS | MINUS | TIMES | DIV) e2=sec_expr )?
	;

prim_expr
	:	FALSE                  # false        
	|	TRUE                   # true
	|	NUM                    # num
	|	ID                     # id
	|	ID LPAR actual RPAR    # funccall
	|	NOT prim_expr          # not
	|	LPAR expr RPAR         # parens
	;

actual
    :   expr?
    ;

// Switch guard declarations EXTENSION
guard
		:	FALSE			#falseg
		|	TRUE			#trueg
		|	NUM				#numg
		|	NUM DOTS NUM	#rangeg
		;

//////// Lexicon

BOOL	:	'bool' ;
ELSE	:	'else' ;
FALSE	:	'false' ;
FUNC	:	'func' ;
IF		:	'if' ;
INT		:	'int' ;
PROC	:	'proc' ;
RETURN 	:	'return' ;
TRUE	:	'true' ;
WHILE	:	'while' ;
// EXTENSION
FOR		:	'for';
TO				:  'to';
SWITCH	: 'switch';
CASE 	: 'case';
DEFAULT	: 'default';
DOTS		:		'..';
// END EXTENSION
EQ		:	'==' ;
LT		:	'<' ;
GT		:	'>' ;
PLUS	:	'+' ;
MINUS	:	'-' ;
TIMES	:	'*' ;
DIV		:	'/' ;
NOT		:	'not' ;

ASSN	:	'=' ;

LPAR	:	'(' ;
RPAR	:	')' ;
COLON	:	':' ;
DOT		:	'.' ;

NUM		:	DIGIT+ ;

ID		:	LETTER (LETTER | DIGIT)* ;

SPACE	:	(' ' | '\t')+   -> skip ;
EOL		:	'\r'? '\n'          -> skip ;
COMMENT :	'#' ~('\r' | '\n')* '\r'? '\n'  -> skip ;

fragment LETTER : 'a'..'z' | 'A'..'Z' ;
fragment DIGIT  : '0'..'9' ;
