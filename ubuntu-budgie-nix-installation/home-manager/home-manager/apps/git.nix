{
  programs.git = {
    enable = true;
    userName = "Dennis Woodruff";
    userEmail = "denniswoodruffuk@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
      push = { default = "current"; };
      pull = { rebase = "true"; };
      rebase = { autoStash = "true"; };
    };
  };
}
