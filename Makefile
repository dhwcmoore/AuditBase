build:
	dune build bin/audit/audit_main.exe

audit:
	dune exec -- bin/audit/audit_main.exe --all

audit-json:
	dune exec -- bin/audit/audit_main.exe --all --json > audit_report.json

ci:
	@$(MAKE) build && $(MAKE) audit
