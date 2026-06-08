namespace LoRARobustness.ToyExample

structure Mat2 where
  a00 : Nat
  a01 : Nat
  a10 : Nat
  a11 : Nat
  deriving Repr, DecidableEq

structure Rank1Adapter where
  b0 : Nat
  b1 : Nat
  a0 : Nat
  a1 : Nat
  deriving Repr, DecidableEq

def deltaW (ad : Rank1Adapter) : Mat2 :=
  { a00 := ad.b0 * ad.a0
    a01 := ad.b0 * ad.a1
    a10 := ad.b1 * ad.a0
    a11 := ad.b1 * ad.a1 }

def exampleAdapter : Rank1Adapter :=
  { b0 := 2, b1 := 3, a0 := 5, a1 := 7 }

def exampleDelta : Mat2 := deltaW exampleAdapter

theorem exampleDelta_is_expected :
    exampleDelta = { a00 := 10, a01 := 14, a10 := 15, a11 := 21 } := by
  rfl

end LoRARobustness.ToyExample
