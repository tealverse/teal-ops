nixos-infect:
	ssh root@$(IP) 'curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-21.11 bash -x'
