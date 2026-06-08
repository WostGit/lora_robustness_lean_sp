namespace LoRARobustness

opaque Scalar : Type
opaque Params : Type
opaque Sample : Type
opaque Label : Type
opaque Time : Type
opaque Dataset : Type
opaque Distribution : Type -> Type

abbrev Vec (n : Nat) := Fin n -> Scalar
abbrev Matrix (m n : Nat) := Fin m -> Fin n -> Scalar

opaque zero : Scalar
opaque one : Scalar
opaque add : Scalar -> Scalar -> Scalar
opaque sub : Scalar -> Scalar -> Scalar
opaque mul : Scalar -> Scalar -> Scalar
opaque div : Scalar -> Scalar -> Scalar
opaque log : Scalar -> Scalar
opaque abs : Scalar -> Scalar

infixl:65 " +s " => add
infixl:65 " -s " => sub
infixl:70 " *s " => mul
infixl:70 " /s " => div

opaque finiteSum {a : Type} : (a -> Scalar) -> Scalar
opaque expectation {a : Type} : Distribution a -> (a -> Scalar) -> Scalar
opaque timeDistribution : Distribution Time
opaque cleanPerturbedPairs : Dataset -> Dataset -> Distribution (Sample × Sample)

opaque F : Params -> Sample -> Scalar
opaque loss : Scalar -> Label -> Scalar
opaque paramUpdate : Dataset -> Time -> Params
opaque paramSub : Params -> Params -> Params
opaque paramNorm : Params -> Scalar
opaque outputLossGrad : Sample -> Params -> Scalar

opaque matVec {m n : Nat} : Matrix m n -> Vec n -> Vec m
opaque matMul {m n p : Nat} : Matrix m n -> Matrix n p -> Matrix m p
opaque transpose {m n : Nat} : Matrix m n -> Matrix n m
opaque eye (n : Nat) : Matrix n n
opaque matSub {m n : Nat} : Matrix m n -> Matrix m n -> Matrix m n
opaque matAdd {m n : Nat} : Matrix m n -> Matrix m n -> Matrix m n
opaque vecInner {n : Nat} : Vec n -> Vec n -> Scalar
opaque affine {m n : Nat} : Matrix m n -> Vec n -> Vec m -> Vec m
opaque mapSigma {n : Nat} : Vec n -> Vec n
opaque eigenvalues {n : Nat} : Matrix n n -> List Scalar
opaque pseudoDet {n : Nat} : Matrix n n -> Scalar
opaque sumScalars : List Scalar -> Scalar
opaque sumPowers : List Scalar -> Scalar -> Scalar
opaque filterPositive : List Scalar -> List Scalar

opaque Kernel : Type
opaque ntk : Sample -> Sample -> Kernel
opaque kernelAdd : Kernel -> Kernel -> Kernel
opaque scalarKernel : Scalar -> Kernel
opaque kernelNorm : Kernel -> Scalar
opaque expectedKernel : Distribution (Sample × Sample) -> ((Sample × Sample) -> Kernel) -> Kernel
opaque fullNTK : Nat -> Nat -> Sample -> Sample -> Kernel
opaque loraNTK : Nat -> Nat -> Sample -> Sample -> Kernel
opaque gpSigma : Nat -> Sample -> Sample -> Scalar
opaque gpSigmaDot : Nat -> Sample -> Sample -> Scalar
opaque fisherInfo : Dataset -> Matrix 1 1
opaque matrixNSD {n : Nat} : Matrix n n -> Prop

/-- Formula 1: empirical risk. -/
def empiricalRisk (theta : Params) (Ntr : Nat) (x : Fin Ntr -> Sample) (y : Fin Ntr -> Label) : Scalar :=
  finiteSum (fun i : Fin Ntr => loss (F theta (x i)) (y i))

/-- Formula 2a: linear preactivation. -/
def layerPreactivation {nout nin : Nat} (W : Matrix nout nin) (b : Vec nout) (x : Vec nin) : Vec nout :=
  affine W x b

/-- Formula 2b: activation. -/
def layerActivation {nout : Nat} (y : Vec nout) : Vec nout := mapSigma y

/-- Formula 3: LoRA update Delta W = B A. -/
def loraDeltaW {nout r nin : Nat} (B : Matrix nout r) (A : Matrix r nin) : Matrix nout nin :=
  matMul B A

/-- Formula 4: LoRA intermediate A x. -/
def loraIntermediate {r nin : Nat} (A : Matrix r nin) (x : Vec nin) : Vec r := matVec A x

/-- Formula 5: training time robustness metric. -/
def trainingTimeRobustnessMetric (D Dtilde : Dataset) : Scalar :=
  expectation (cleanPerturbedPairs D Dtilde) (fun _pair =>
    expectation timeDistribution (fun t =>
      paramNorm (paramSub (paramUpdate D t) (paramUpdate Dtilde t))))

/-- Formula 6: NTK placeholder. -/
def ntkFormula (x xprime : Sample) : Kernel := ntk x xprime

/-- Formula 7: simplified TTR proxy. -/
def simplifiedTTRProxy (D Dtilde : Dataset) : Scalar :=
  kernelNorm (expectedKernel (cleanPerturbedPairs D Dtilde) (fun p => ntk p.1 p.2))

/-- Formula 8: Fisher placeholder. -/
def fisherFromParameterGradients (Dtilde : Dataset) : Matrix 1 1 := fisherInfo Dtilde

axiom fisher_weighted_ntk_bridge (Dtilde : Dataset) :
  fisherFromParameterGradients Dtilde = fisherInfo Dtilde

/-- Formula 9: information bits as log pseudo determinant. -/
def informationBitsLogDet {n : Nat} (Itheta : Matrix n n) : Scalar :=
  (one /s (one +s one)) *s log (pseudoDet Itheta)

/-- Formula 9: paper eigenvalue transcription. -/
def informationBitsPaperEigenLiteral {n : Nat} (Itheta : Matrix n n) : Scalar :=
  (one /s (one +s one)) *s sumScalars (filterPositive (eigenvalues Itheta))

/-- Formula 10: Renyi entropy shape. -/
def renyiEntropy {n : Nat} (alpha : Scalar) (Itheta : Matrix n n) : Scalar :=
  (one /s (one -s alpha)) *s log (sumPowers (eigenvalues Itheta) alpha)

/-- Formula 11: GP covariance placeholder. -/
def gaussianProcessCovariance (l : Nat) (x xprime : Sample) : Scalar := gpSigma l x xprime

/-- Formula 12: full fine tuning NTK placeholder. -/
def fullFineTuningNTK (l k : Nat) (x xprime : Sample) : Kernel := fullNTK l k x xprime

/-- Formula 13: activation derivative covariance placeholder. -/
def activationDerivativeCovariance (l : Nat) (x xprime : Sample) : Scalar := gpSigmaDot l x xprime

/-- Formula 14a: LoRA NTK placeholder. -/
def loraNTKFormula (l k : Nat) (x xprime : Sample) : Kernel := loraNTK l k x xprime

/-- Formula 14b: LoRA covariance term. -/
def loraCovarianceTerm {r n : Nat} (A : Matrix r n) (yx yxprime : Vec n) : Scalar :=
  vecInner yx (matVec (matMul (transpose A) A) yxprime)

/-- Formula 14c: W_LoRA = W0 + B A. -/
def loraWeight {nout r nin : Nat} (W0 : Matrix nout nin) (B : Matrix nout r) (A : Matrix r nin) : Matrix nout nin :=
  matAdd W0 (loraDeltaW B A)

/-- Formula 15b: residual y^T(A^T A - I)y'. -/
def deltaResidualScalar {r n : Nat} (A : Matrix r n) (yx yxprime : Vec n) : Scalar :=
  vecInner yx (matVec (matSub (matMul (transpose A) A) (eye n)) yxprime)

/-- Formula 15a: relationship recorded as an assumption. -/
axiom oold_ntk_relationship {r n : Nat} (l k : Nat) (A : Matrix r n) (x xprime : Sample) (yx yxprime : Vec n) :
  loraNTKFormula l k x xprime = kernelAdd (fullFineTuningNTK l k x xprime) (scalarKernel (deltaResidualScalar A yx yxprime))

/-- Formula 16: backdoor gradient objective. -/
def backdoorGradientObjective (xc xt : Sample) (theta : Params) : Scalar :=
  abs ((outputLossGrad xc theta) *s (outputLossGrad xt theta))

/-- Formula 17: untargeted poisoning gradient objective. -/
def untargetedPoisoningGradientObjective (xc xu : Sample) (theta : Params) : Scalar :=
  abs ((outputLossGrad xc theta) *s (outputLossGrad xu theta))

/-- Formula 18: approximate entropy from A^T A. -/
def approximateRenyiFromLoRAGram {r n : Nat} (alpha : Scalar) (A : Matrix r n) : Scalar :=
  (one /s (one -s alpha)) *s log (sumPowers (eigenvalues (matMul (transpose A) A)) alpha)

def gramResidual {r n : Nat} (A : Matrix r n) : Matrix n n := matSub (matMul (transpose A) A) (eye n)

axiom theorem_3_4_gramResidual_NSD {r n : Nat} (A : Matrix r n) (rankCondition : r <= n) (varianceCondition : Prop) :
  matrixNSD (gramResidual A)

end LoRARobustness
