import LoRARobustness.FormulaBook

namespace LoRARobustness

inductive ThreatKind where
  | BackdoorPoisoning
  | UntargetedPoisoning
  | MembershipInference
  deriving Repr, DecidableEq

inductive PrivacyMechanismKind where
  | DifferentialPrivacy
  | SignQuantization
  deriving Repr, DecidableEq

inductive InteractionDirection where
  | PositiveSynergy
  | MixedTradeoff
  | UnknownNeedsExperiment
  deriving Repr, DecidableEq

structure LoRAKnobs where
  rank : Nat
  varianceScale : String
  humanNote : String
  deriving Repr

structure PrivacyConfig where
  mechanism : PrivacyMechanismKind
  mechanismParameter : String
  humanNote : String
  deriving Repr

structure RobustnessPrivacyInteraction where
  threat : ThreatKind
  loraKnobs : LoRAKnobs
  privacy : PrivacyConfig
  direction : InteractionDirection
  mechanismSummary : String
  expectedBenefit : String
  expectedRisk : String
  reviewerCaveat : String
  deriving Repr

def defaultLowRankLoRA : LoRAKnobs := {
  rank := 8,
  varianceScale := "small default variance",
  humanNote := "Low rank shrinks the update manifold. This helps backdoor resistance but can increase sensitivity to untargeted poisoning."
}

def dpFineTuning : PrivacyConfig := {
  mechanism := PrivacyMechanismKind.DifferentialPrivacy,
  mechanismParameter := "clipping plus additive noise",
  humanNote := "DP limits the effect of one example or client update."
}

def signQuantizedPrivacy : PrivacyConfig := {
  mechanism := PrivacyMechanismKind.SignQuantization,
  mechanismParameter := "subset aggregation plus sign releases",
  humanNote := "Sign releases reduce update precision and target membership inference resistance."
}

def dpLoraBackdoorSynergy : RobustnessPrivacyInteraction := {
  threat := ThreatKind.BackdoorPoisoning,
  loraKnobs := defaultLowRankLoRA,
  privacy := dpFineTuning,
  direction := InteractionDirection.PositiveSynergy,
  mechanismSummary := "LoRA smooths the update space and DP limits individual poisoned-update influence.",
  expectedBenefit := "Backdoor insertion should become harder in private LoRA fine tuning.",
  expectedRisk := "Too much noise can reduce clean utility.",
  reviewerCaveat := "This is a qualitative hypothesis unless backed by experiments."
}

def signLoraPoisoningTradeoff : RobustnessPrivacyInteraction := {
  threat := ThreatKind.UntargetedPoisoning,
  loraKnobs := defaultLowRankLoRA,
  privacy := signQuantizedPrivacy,
  direction := InteractionDirection.MixedTradeoff,
  mechanismSummary := "Aggregation can dilute some poisons, but sign flips in low-rank directions may still harm utility.",
  expectedBenefit := "Aggregation can reduce single-sample influence.",
  expectedRisk := "Poisoning that changes aggregate signs can exploit the low-rank bottleneck.",
  reviewerCaveat := "Needs controlled experiments over rank and poison rate."
}

end LoRARobustness
