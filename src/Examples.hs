
--BEGIN:Firs4
f(x) = x * 2
--END:Firs4

--BEGIN:Loca8
test1 = let x = 3 in 2*x + 5
--END:Loca8

--BEGIN:Loca10
test2 = 2 * (let x = 3 in x + 5)
--END:Loca10

--BEGIN:Loca15
test3 = let x = 3 in let y = x*2 in x + y
--END:Loca15

--BEGIN:Loca17
test4 = let x = 3 in (let y = x*2 in x + y)
--END:Loca17

--BEGIN:Usin3
f'1(x) = x * 2
f'2 x  = x * 2
f'3 = \x -> x * 2
--END:Usin3

testLet =
--BEGIN:Recu3
  let fact = \n -> if n == 0 then 1 else n * fact(n-1)
  in fact(10)
--END:Recu3

--BEGIN:Recu7
testLet3 = let x = x + 1 in x
--END:Recu7

testLet2 =
--BEGIN:Recu9
  let x = y + 1
      y = 99
  in x * y
--END:Recu9


--BEGIN:A63
testID = id(id)   
-- returns id
--END:A63

--BEGIN:Prob22
testP = let k = 2 in
  let double = \n -> k * n in
    let k = 9 in
      double k
--END:Prob22


main = return ()
