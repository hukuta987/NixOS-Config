{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Version & Locales
  system.stateVersion = "25.11";
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
  };

  # Fish
  programs.fish.enable = true;
  users.users.hukuta = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Xorg
  services.xserver = {
    enable = true;
    xkb.layout = "us,ru";
    xkb.options = "grp:alt_shift_toggle";
  };
  services.xserver.videoDrivers = [ "nvidia" ]; # intel or amdgpu

  # Nvidia ( Optional )
  nixpkgs.config.allowUnfree = true;
  hardware.nvidia.open = false;

  # Window Manager
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs (oldAttrs: {
      src = /etc/nixos/dwm;
    });
  };

  # Zapret
  services.zapret = {
    enable = true;
    params = [
      "--dpi-desync=fake,fakeddisorder"
      "--dpi-desync-fooling=datanoack"
      "--dpi-desync-split-pos=midsld"
    ];
    whitelist = [
       "
       discord.com
       discord-attachments-uploads-prd.storage.googleapis.com
       googleapis.com
       googlevideo.com
       ytimg.com
       youtube.com
       youtu.be
       "
    ];
  };

  # V2Ray
  services.v2raya = {
    enable = true;
  };


  # Throne
  programs.throne.package = pkgs.throne;
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
  boot.kernelModules = [ "tun" ];
  networking.useNetworkd = true;

  # Packages
  environment.systemPackages = with pkgs; [
    vesktop
    picom-pijulius
    throne
    nnn
    ppsspp
    gnumake
    wmctrl
    p7zip
    dejavu_fonts
    obsidian
    playerctl
    xdelta
    spotify
    v2raya
    ueberzug
    openssh
    prismlauncher
    zapret
    util-linux
    coreutils
    fastfetch
    feh
    fish
    telegram-desktop
    kitty
    firefox
    btop
    neovim
    dunst
    spotifyd
    unzip
    cava
    viu
    eww
    dmenu
    sxiv
    flameshot
    xclip
    tty-clock
    clipmenu
    git
    xorg.xrandr
    xorg.xsetroot
    xcursor-themes
  ];

  # Network
  networking.networkmanager.enable = true;

  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Sudo (Optional)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;


}
