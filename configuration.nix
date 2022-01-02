{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  environment.etc.hosts.mode = "0644";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yakuri354-laptop";

  time.timeZone = "Europe/Moscow";

  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.extraOptions = ''
    binary-caches-parallel-connections = 12
    experimental-features = nix-command flakes ca-references
  '';

  # Binary Cache for Haskell.nix
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io"
  ];

  nix.package = pkgs.nixFlakes;

  services.dbus.packages = with pkgs; [ gnome3.dconf ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.xserver.layout = "ru";
  services.xserver.xkbOptions = "eurosign:e";

  security.rtkit.enable = true;

  # Add PipeWire instead of Pulseaudio
  hardware.pulseaudio.enable = false;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.xserver.libinput.enable = true;
  
  programs.fish.enable = true;
  
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';

  nix.trustedUsers = [ "root" "yakuri354" ];

  users.users.yakuri354 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "scanner" "lp" ]; # Enable ‘sudo’ for the user.
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
  };

  environment.variables.EDITOR = "vim";
  
  nixpkgs.config.allowUnfree = true; # :sad:
  
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplipWithPlugin
    ];
  };

  hardware.sane = { 
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  services.openvpn.servers = {
    private = {
      config = "config /etc/vpn/private.conf"; 
      autoStart = false;
    }; 
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    clang
    nano
    powertop
    cachix
    any-nix-shell
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

