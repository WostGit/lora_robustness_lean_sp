.PHONY: quickstart reproduce lean-build ci-local clean

quickstart:
	bash scripts/reviewer_quickstart.sh

reproduce:
	bash scripts/reproduce_toy_results.sh

lean-build:
	lake build

ci-local: quickstart lean-build

clean:
	rm -rf .lake build logs/toy_lora_privacy_results.csv logs/ci_summary.md logs/lean_build_status.md
