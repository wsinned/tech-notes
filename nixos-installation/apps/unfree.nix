{ pkgs, ... }:

{
	home.packages = with pkgs; [

		discord
		slack
		vscode
   	google-chrome
		meld
		insync
		
	];
}
