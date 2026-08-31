{ config, pkgs, ... }:
{
    home.username = "biruk";
    home.homeDirectory = "/home/biruk";
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        settings = {
            user.name = "imbiruk";
            user.email = "birukerjamo@gmail.com";
            init.defaultBranch = "main";
        };
    };
}
