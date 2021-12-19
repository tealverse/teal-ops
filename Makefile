NIX_PATH?="nixpkgs=https://github.com/NixOS/nixpkgs/archive/6d684ea3adef590a2174f2723134e1ea377272d2.tar.gz"

nixos-infect:
	ssh root@$(IP) 'curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-21.11 bash -x'

deploy-prepare:
	nixops delete --all --force
	nixops create ./network/network.nix -d teal-build

deploy:
	NIX_PATH=$(NIX_PATH) \
	nix-shell -p nixops \
	--run "make deploy-prepare; nixops deploy -d teal-build"

# deploy-dry-activate:
# 	NIX_PATH=$(NIX_PATH) \
# 	nix-shell -p nixops \
# 	--run "make deploy-prepare; nixops deploy --dry-activate -d teal"

# deploy-dry-run:
# 	NIX_PATH=$(NIX_PATH) \
# 	nix-shell -p nixops \
# 	--run "make deploy-prepare; nixops deploy --dry-run -d teal"
