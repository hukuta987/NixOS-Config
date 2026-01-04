{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Version & Locales
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Moscow";

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
      src = /etc/nixos/dwm-src;
    });
  };

  # Packages
  environment.systemPackages = with pkgs; [
    #(import ./pkgs/v2rayN.nix {inherit pkgs; })
    picom
    xterm
    ranger
    gnumake
    fastfetch
    feh
    firefox
    btop
    neovim
    unzip
    dmenu
    flameshot
    xclip
    clipmenu
    git
    xorg.xrandr
    xorg.xsetroot
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
  # security.sudo.enable = true;
  # security.sudo.wheelNeedsPassword = false;

  # .xinitrc
  system.activationScripts.createXinitrc = {
    text = ''
      cat > $HOME/.xinitrc <<'EOF'
      picom &
      exec dwm
      EOF
      chmod +x $HOME/.xinitrc
    '';
  };
}
