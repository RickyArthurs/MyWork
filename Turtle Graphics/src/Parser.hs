{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
module Parser where
import Ast
import Text.Parsec
import Text.Parsec.Expr
import Text.Parsec.Language
import Text.Parsec.Token
import Graphics.Gloss.Data.Color
import Data.Bool (Bool(True))
import Data.Bool (Bool(False))
defName = "defName"

{- This file contains the parser, which uses Parsec to parse a MiniTurtle
 - program into the AST. -}

-- Parser type: a Parsec parser, operating on strings, with no state
type Parser a = Parsec String () a

-- Two examples provided: parsing a colour and an integer
color :: Parser Color
color =
    (reserved lexer "red" >> return red)
    <|> (reserved lexer "green" >> return green)
    <|> (reserved lexer "blue" >> return blue)
    <|> (reserved lexer "yellow" >> return yellow)
    <|> (reserved lexer "black" >> return black)

int :: Parser Int
int = do
  digits <- many1 digit
  return (read digits)

intExpr :: Parser Expr
intExpr = do
    i <- int
    return (EInt i)

bool :: Parser Bool
bool = (reserved lexer "true" >> return True) <|> (reserved lexer "false" >> return False)

boolExpr :: Parser Expr
boolExpr = do
    b <- bool
    return (EBool b)


unitExpr :: Parser Expr
unitExpr = char '(' >> char ')' >> (return EUnit)

var :: Parser Expr
var = do
    v <- identifier lexer
    return (EVar v)

changeColor :: Parser Expr
changeColor = do
    reserved lexer "changeColor"
    char '('
    col <- color
    char ')'
    return (EChangeColor col)

move :: Parser Expr
move = do
    dire <- (reserved lexer "forward" >> return Forward) <|> (reserved lexer "backward" >> return Backward)
    ex <- parens lexer expression
    return (EMove dire ex)

rotate :: Parser Expr
rotate = do
    dire <- (reserved lexer "left" >> return RotateLeft) <|> (reserved lexer "right" >> return RotateRight)
    ex <- parens lexer expression
    return (ERotate dire ex)

actionExpr :: Parser Expr
actionExpr = changeColor
    <|> move
    <|> rotate
    <|> (reserved lexer "penDown" >> string "()" >> return EPenDown)
    <|> (reserved lexer "penUp" >> string "()" >> return EPenUp)

letExpr :: Parser Expr
letExpr = do
   reserved lexer "let"
   var <- identifier lexer
   reserved lexer "="
   expr' <- expr
   reserved lexer "in"
   body <- expr
   return (ELet var expr' body)

condExpr :: Parser Expr
condExpr = do
   reserved lexer "if"
   char '{'
   predicate <- expr
   char '}'
   reserved lexer "then"
   char '{'
   ifBranch <- expr
   char '}'
   reserved lexer "else"
   char '{'
   elseBranch <- expr
   char '}'
   return (EIf predicate ifBranch elseBranch)

typeExpr :: Parser Type
typeExpr = (reserved lexer "Int" >> return TyInt) 
        <|> (reserved lexer "Bool" >> return TyBool) 
        <|> (reserved lexer "Unit" >> return TyUnit)

    
blockExpr :: Parser Expr
blockExpr = do
    string "{"
    e <- expr
    string "}"
    return e
    
{- Exercise 4 -}
expr :: Parser Expr
expr =
  try intExpr
  <|> try boolExpr
  <|> try unitExpr
  <|> try actionExpr
  <|> try condExpr
  <|> try letExpr
  <|> var
  <|> parens lexer expression

program :: Parser Program
program = do
    defs <- def
    body <- blockExpr
    return ([(defNameGen defName, defs)], body)

def :: Parser Definition
def = do
    reserved lexer "def"
    ident <- identifier lexer
    char '('
    params <- paramListNonEmpty
    char ')'
    char ':'
    t <- typeExpr
    b <- blockExpr
    return (params, t, b)

paramListNonEmpty :: Parser [(Parameter, Type)]
paramListNonEmpty = do
    p <- param
    ps <- (try (char ',' >> paramListNonEmpty) <|> (return []))
    return (p : ps)

param :: Parser (Parameter, Type)
param = do
    ident <- identifier lexer
    char ':'
    t <- typeExpr
    return (ident, t)

defNameGen :: String -> DefName
defNameGen a = a

{- The remainder of the file is boilerplate which we have set up for you.
 - This includes setting up the expression parser, which means you do not
 - need to worry about unary and binary operators. -}
keywords = [
        "forward", "backward", "left", "right",
        "penUp", "penDown", "changeColor", "red",
        "green", "blue", "yellow", "black", "if", "else",
        "let", "in", "true", "false", "def"
    ]

ops = [
        "+", "-", "*", "/", "==", "!=", ">", "<",
        ">=", "<=", "&&", "||"
    ]

langDef :: LanguageDef ()
langDef = emptyDef {
        commentStart = "/*",
        commentEnd = "*/",
        commentLine = "//",
        identStart = letter <|> (char '_'),
        identLetter = alphaNum <|> char '_',
        opStart = oneOf ";!&*+/<=>|-",
        opLetter = oneOf "&/=|",
        reservedNames = keywords,
        reservedOpNames = ops,
        caseSensitive = True
    }

lexer :: TokenParser ()
lexer = makeTokenParser langDef

binary  name fun assoc =
    Infix ( do { reservedOp lexer name; return fun }) assoc

prefix  name fun =
    Prefix (do { reservedOp lexer name; return fun })

postfix name fun =
    Postfix (do{ reservedOp lexer name; return fun })

table =
    [  [prefix "-" (EUnOp Neg), prefix "!" (EUnOp Not) ]
       , [binary "*" (EBinOp Mul) AssocLeft, binary "/" (EBinOp Div) AssocLeft ]
       , [binary "+" (EBinOp Add) AssocLeft, binary "-" (EBinOp Sub) AssocLeft ]
       , [ binary "<" (EBinOp Less) AssocLeft, binary "<=" (EBinOp LessEq) AssocLeft,
           binary ">" (EBinOp Greater) AssocLeft, binary ">=" (EBinOp GreaterEq) AssocLeft,
           binary "==" (EBinOp Eq) AssocLeft, binary "!=" (EBinOp Neq) AssocLeft
         ]
       , [binary "&&" (EBinOp And) AssocLeft, binary "||" (EBinOp Or) AssocLeft]
       , [binary ";" ESeq AssocRight]
    ]

expression :: Parser Expr
expression = buildExpressionParser table expr

-- External definition, which runs the parser
parse :: String -> String -> Either ParseError Program
parse = runP program ()
