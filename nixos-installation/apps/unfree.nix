{ pkgs, ... }:

{
	home.packages = with pkgs; [
		authy
		discord
		slack

		## Things to remember to install manually

		# vscode
    	# google-chrome # break glass in case of emergency
		# meld

		# Insync
		
	];
}
