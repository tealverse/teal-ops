nixos-infect:
	ssh root@$(IP) 'curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-21.11 bash -x'

deploy-clear:
	nixops delete -d teal

deploy-prepare:
	nixops create ./server/network.nix -d teal
	nixops info -d teal

deploy-dry-run: deploy-prepare 	
deploy-dry-run:
	nixops deploy --dry-run -d teal

ci:
	