import Lake
open Lake DSL

package «lora_robustness_lean_sp» where
  version := v!"0.5.0"

lean_lib LoRARobustness where
  roots := #[`LoRARobustness]
