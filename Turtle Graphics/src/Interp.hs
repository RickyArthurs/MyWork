module Interp (eval) where
import Ast
import Instruction

-- An environment maps variables to values. This allows you to look up
-- what a variable stands for when you use it (for example, after let-binding,
-- or using a parameter)
type Env = [(Variable, Value)]

-- TurtleState is a Haskell record which contains the state you will need when
-- evaluating. It contains the environment, the definition map, and the list of
-- instructions that you are building up.
data TurtleState = TS {
    env :: Env,
    definitions :: [(DefName, Definition)],
    instructions :: [Instruction]
}

-- Constructs an empty state, given a definition map
emptyState :: [(DefName, Definition)] -> TurtleState
emptyState defs = TS { env = [], definitions = defs, instructions = [] }

{- Exercise 2 -}
evalUnOp :: UnaryOp -> Value -> Value
evalUnOp Neg (VInt i) = VInt (-i)
evalUnOp Neg (VBool b)  = VBool (not b)
evalUnOp Not (VBool b) = VBool (not b)

evalBinOp :: BinaryOp -> Value -> Value -> Value
evalBinOp Add (VInt i1) (VInt i2) = VInt (i1 + i2)
evalBinOp Sub (VInt i1) (VInt i2) = VInt (i1 - i2)
evalBinOp Div (VInt i1) (VInt i2) = VInt (i1 `div` i2)
evalBinOp Mul (VInt i1) (VInt i2) = VInt (i1 * i2)
evalBinOp Eq (VInt i1) (VInt i2) = VBool (i1 == i2)
evalBinOp Neq (VInt i1) (VInt i2) = VBool (i1 /= i2)
evalBinOp Greater (VInt i1) (VInt i2) = VBool (i1 > i2)
evalBinOp Less (VInt i1) (VInt i2) = VBool (i1 < i2)

{- Exercise 3 -}
addInstruction :: TurtleState -> Instruction -> TurtleState
addInstruction ts i =
    ts { instructions = instructions ts ++ [i] }

bind :: TurtleState -> Variable -> Value -> TurtleState
bind ts var val =
    ts { env = (var, val) : env ts }

lookupVar :: TurtleState -> Variable -> Value
lookupVar ts var =
    case lookup var (env ts) of
        Just v  -> v
        Nothing -> error $ "Var not found: " ++ show var

lookupDef :: TurtleState -> DefName -> Definition
lookupDef ts name =
    case lookup name (definitions ts) of
        Just d -> d
        Nothing -> error $ "Def not found: " ++ show name

combine :: [a] -> [a] -> [[a]]
combine pair1 pair2 = [ [a, b] | (a, b) <- zip pair1 pair2]

{- Exercise 4 -}
evalExpr :: TurtleState -> Expr -> (Value, TurtleState)
evalExpr st (EInt i) = (VInt i, st)
evalExpr st (EBool b) = (VBool b, st)
evalExpr st (EVar var) = (lookupVar st var, st)
evalExpr st EUnit = (VUnit, st)
evalExpr st (EUnOp op e) = let (v, s) = evalExpr st e
                              in (evalUnOp op v, s)
evalExpr st (EBinOp op e1 e2) = let    (v1, s1) = evalExpr st e1
                                       (v2, s2) = evalExpr s1 e2
                                in (evalBinOp op v1 v2, s2)
evalExpr st (EApp def args) =  
    let (params, retType, body) = lookupDef st def
        -- evaluate the argument expressions
        (vals, st1) = foldl (\(vs, s) e -> let (v, s1) = evalExpr s e
                                           in (vs ++ [v], s1)) ([], st) args
        -- create the new environment
        env' = zip (map fst params) vals
        defSt = TS {env = env', definitions = definitions st1, instructions = instructions st1}
    in  evalExpr defSt body
evalExpr st (EIf cond e1 e2) = 
    let (b, st1) = evalExpr st cond
    in  if b == VBool True then evalExpr st1 e1 else evalExpr st1 e2
evalExpr st (EChangeColor color) = 
    let inst = IChangeColor color
    in  (VUnit, addInstruction st inst)
evalExpr st (EMove dir e) = 
    let (VInt d, st1) = evalExpr st e
        inst = IMove d
    in  (VUnit, addInstruction st1 inst)
evalExpr st (ERotate dir e) = 
    let (VInt angle, st1) = evalExpr st e
        inst = IRotate angle
    in  (VUnit, addInstruction st1 inst)
evalExpr st EPenUp = (VUnit, addInstruction st IPenUp)
evalExpr st EPenDown = (VUnit, addInstruction st IPenDown)
evalExpr st (ELet var e1 e2) = 
    let (v, st1) = evalExpr st e1
        st2 = bind st1 var v
    in  evalExpr st2 e2
evalExpr st (ESeq e1 e2) = 
    let (_, st1) = evalExpr st e1
    in  evalExpr st1 e2

-- helper function
evalArgs :: TurtleState -> [Expr] -> ([Value], TurtleState)
-- evalArgs (TS env defs instrs) args = error "fill me in"
evalArgs st [] = ([], st)

-- External function
eval :: Program -> (Value, [Instruction])
eval (defs, expr) = let (val, turtleState) = evalExpr turtleState expr
                    in (val, instructions turtleState)
