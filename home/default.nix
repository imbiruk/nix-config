{ config, pkgs, ... }:
{
    home.username = "biruk";
    home.homeDirectory = "/home/biruk";
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        userName = "imbiruk";
        userEmail = "birukerjamo@gmail.com";
        extraConfig.init.defaultBranch = "main";
  };
}
