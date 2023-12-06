{ pkgs, ... }:

{
	home.packages = with pkgs; [
		authy
		discord
		slack
		# vscode
	];
}
