module StatefulMonad where

import Prelude hiding (LT, GT, EQ, id)
import Base
import Data.Maybe
import Stateful hiding (Stateful, evaluate)
import Control.Monad

--BEGIN:StatefulMonad1
data Stateful t = ST (Memory -> (t, Memory))
--END:StatefulMonad1

instance Functor Stateful where
  fmap  = liftM

--BEGIN:StatefulMonad2 
instance Applicative Stateful where
  pure val = ST (\m -> (val, m))
  (<*>) = ap 

instance Monad Stateful where
  return = pure
  (ST c) >>= f = 
    ST (\m -> 
      let (val, m') = c m in
        let ST f' = f val in
          f' m'
      )
--END:StatefulMonad2
        
--BEGIN:StatefulMonad3
evaluate :: Exp -> Env -> Stateful Value
-- basic operations
evaluate (Literal v) env = return v
evaluate (Unary op a) env = do
  av <- evaluate a env
  return (unary op av)
evaluate (Binary op a b) env = do
  av <- evaluate a env
  bv <- evaluate b env
  return (binary op av bv)
evaluate (If a b c) env = do
  cond <- evaluate a env
  case cond of 
    BoolV t -> evaluate (if t then b else c) env
-- variables and declarations
evaluate (Declare x e body) env = do    -- non-recursive case
  ev <- evaluate e env
  let newEnv = (x, ev) : env
  evaluate body newEnv
evaluate (Variable x) env = 
  return (fromJust (lookup x env))

-- first-class functions
evaluate (Function x body) env = 
  return (ClosureV  x body env)
evaluate (Call fun arg) env = do
  closure <- evaluate fun env
  case closure of
    ClosureV x body closeEnv -> do
      argv <- evaluate arg env
      let newEnv = (x, argv) : closeEnv
      evaluate body newEnv

-- mutation operations
evaluate (Seq a b) env = do
  evaluate a env
  evaluate b env
evaluate (Mutable e) env = do
  ev <- evaluate e env
  newMemory ev        
evaluate (Access a) env = do
  addr <- evaluate a env
  case addr of
    AddressV i -> readMemory i
evaluate (Assign a e) env = do
  addr <- evaluate a env
  ev <- evaluate e env
  case addr of
    AddressV i -> updateMemory ev i
--END:StatefulMonad3

--BEGIN:StatefulHelper1
newMemory val = ST (\mem-> (AddressV (length mem), mem ++ [val]))
--END:StatefulHelper1

--BEGIN:StatefulHelper2
readMemory i = ST (\mem-> (access i mem, mem))
--END:StatefulHelper2

--BEGIN:StatefulHelper3
updateMemory val i = ST (\mem-> (val, update i val mem))
--END:StatefulHelper3

runStateful (ST c) = 
   let (val, mem) = c [] in val



  