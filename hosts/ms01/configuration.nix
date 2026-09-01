{ config, lib, pkgs, inputs, ... }:

{
    imports =
        [ 
            ./hardware-configuration.nix
        ];

    boot.loader.timeout = 0;
    boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 1;
    boot.kernelParams = [ "quiet" "udev.log_level=3" ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings = {
        experimental-features = ["nix-command" "flakes"];
        http-connections = 50;
        max-substitution-jobs = 32;
    };
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };
    networking.hostName = "nixos";

    networking.networkmanager.enable = true;

    time.timeZone = "Africa/Addis_Ababa";

    users.users.biruk = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.nushell;
    };

    environment.shells = with pkgs; [ nushell bash ];

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
        };
    };

    users.users.biruk.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGAZLrnW+5JsWzzIZvSOwOVjvbeuJC6lKJ+ZA/yp4yk biruk@Mac"
    ];

    services.greetd = {
        enable = true;
        settings = {
            initial_session = {
                command = "niri-session";
                user = "biruk";
            };
            default_session = {
                command = "${pkgs.greetd}/bin/agreety --cmd niri-session";
                user = "greeter";
            };
        };
    };
    system.stateVersion = "26.05";

    programs.niri.enable = true;

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            vpl-gpu-rt
        ];
    };

    security.polkit.enable = true;
    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    fonts = {
        packages = with pkgs; [
            nerd-fonts.iosevka
            (iosevka-bin.override { variant = "Aile"; })
            noto-fonts
            noto-fonts-color-emoji
        ];
        fontconfig.defaultFonts = {
            monospace = [ "Iosevka Nerd Font Mono" "Noto Color Emoji" ];
            sansSerif = [ "Iosevka Aile" "Noto Sans" "Noto Color Emoji" ];
            serif     = [ "Iosevka Aile" "Noto Serif" "Noto Color Emoji" ];
        };
    };

    services.gvfs.enable = true;

    security.rtkit.enable = true;
    services.pipewire.alsa.enable = true;
    programs.dconf.enable = true;

    programs.steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    hardware.graphics.enable32Bit = true;

    programs.gamemode.enable = true;
    environment.variables.SUDO_EDITOR = "nvim";
    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
        LIBVA_DRIVER_NAME = "iHD";
    };

    environment.systemPackages = with pkgs; [
        fuzzel
        adwaita-icon-theme
        xwayland-satellite
        swaylock
        wl-clipboard
        mako
        telegram-desktop
        neovim
        ghostty
        git
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        rsync
        sqlite
        nushell
        tmux
        yazi
        gcc
        gnumake
        tree-sitter
        tree
        waybar
        swaybg
        bibata-cursors
        papirus-icon-theme
        gnome-themes-extra
        nwg-look
        pavucontrol
        brightnessctl
        playerctl
        libnotify
        gh
        pcmanfm
        spotify
        mangohud
        gamemode
        ripgrep
        vimPlugins.blink-cmp
    ];

    nixpkgs.config.allowUnfree = true;
}
