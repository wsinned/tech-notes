{ pkgs, ... }:

{
	programs.zsh = {
	    enable = true;
	    enableCompletion = true;
	    enableAutosuggestions = true;
	    syntaxHighlighting.enable = true;
	    oh-my-zsh = {
	      enable = true;
	      plugins = [ "git" "docker-compose" "docker" "asdf" ];
	    };
	    initExtraBeforeCompInit = ''
	      # p10k instant prompt
	      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
	      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
	    '';
	    plugins = [
	      {
		name = "powerlevel10k";
		src = pkgs.zsh-powerlevel10k;
		file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
	      }
	      {
		name = "powerlevel10k-config";
		src = ./p10k-config;
		file = ".p10k.zsh";
	      }
	    ];
	    initExtra = ''
			  
	      bindkey '^f' autosuggest-accept
	      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
	      [[ ! -f ~/scripts/aliases.sh ]] || source ~/scripts/aliases.sh 

	    '';
	  };
}
