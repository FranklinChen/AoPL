module TopLevelFunctions where

import Prelude hiding (LT, GT, EQ, showList)
import Data.Maybe
import Value
import Operators


--BEGIN:Top15
type FunEnv = [(String, Function)]
data Function = Function [String] Exp
--END:Top15
  deriving Show

--BEGIN:Top18
data Program = Program FunEnv Exp
--END:Top18
  deriving Show

--BEGIN:Summ12
data Exp = Literal   Value
         | Unary     UnaryOp Exp
         | Binary    BinaryOp Exp Exp
         | If        Exp Exp Exp
         | Variable  String
         | Declare   String Exp Exp
         | Call      String [Exp]
  deriving Show
            
--BEGIN:Eval59
evaluate :: Exp -> Env -> FunEnv -> Value
--END:Eval59
evaluate (Literal v) env funEnv = v

evaluate (Unary op a) env funEnv = 
  unary op (evaluate a env funEnv)

evaluate (Binary op a b) env funEnv = 
  binary op (evaluate a env funEnv) (evaluate b env funEnv)

evaluate (If a b c) env funEnv = 
  let BoolV test = evaluate a env funEnv in
    if test then evaluate b env funEnv
            else evaluate c env funEnv

evaluate (Variable x) env funEnv = fromJust (lookup x env)

evaluate (Declare x exp body) env funEnv = 
  evaluate body newEnv funEnv
    where newEnv = (x, evaluate exp env funEnv) : env

--BEGIN:Eval31
evaluate (Call fun args) env funEnv = evaluate body newEnv funEnv
  where Function xs body = fromJust (lookup fun funEnv)
        newEnv = zip xs [evaluate a env funEnv | a <- args]
--END:Summ12 END:Eval31

