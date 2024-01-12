# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos-pkgs/docker.nix
    ./qmk-support.nix

    ../../nixos-pkgs/virt-manager.nix
    ../../nixos-pkgs/steam.nix
    # ../../desktop/i3
    ../../desktop/awesome

    # Grub
    ../../nixos-pkgs/grub/os-prober.nix

    # ../../nixos-pkgs/display-managers/lightdm.nix
  ];

  hardware.opengl.setLdLibraryPath = true;

  hardware.nvidia.open = true;

  services.devmon.enable = true;
  services.udisks2.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      gnome.enable = true;
      # cinnamon.enable = true;
    };
    windowManager.awesome.enable = true;
    libinput.enable = true;

    displayManager = {
      gdm.enable = true;
      # lightdm.enable = true;
    };

    videoDrivers = [ "nvidia" ];
    layout = "us";
    xkbVariant = "";
  };

  services.dbus.packages = with pkgs; [ dconf ];
  programs.dconf.enable = true;
  programs.noisetorch.enable = true;

  networking = {
    hostName = "nixos";

    # DNS
    networkmanager = {
      enable = true;
      dns = "none";
      # ethernet.macAddress = "random";
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall = {
      enable = false;
    };
  };


  # Resolvconf is automatically picking up unwanted ISP's dns server ip and
  # giving it higher priority than `networking.nameservers`, so we just don't
  # use it and manually manage DNS.
  environment.etc = {
    "resolv.conf".text = "nameserver 1.1.1.3\n";
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };

    settings = {
      # Caching
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      auto-optimise-store = true;
    };
  };

  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;


  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "changeme";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
