{ config, pkgs, ... }:

let
  neovim-cfg = import ./neovim.nix;
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "yakuri354";
  home.homeDirectory = "/home/yakuri354";

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Papirus-Dark";
  };
  
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Nikita Kurlaev";
    userEmail = "2024kurlaev.nv@student.letovo.ru";
    extraConfig = {
      init.defaultBranch = "master";
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "exa --tree -L 1 --icons";
      la = "exa --icons --header --long --all";
      lls = "exa --tree --icons";
    };
    shellAbbrs = {
      hm = "home-manager";
      nsh = "nix shell nixpkgs#";
      npi = "nix profile install nixpkgs#";
    };
    
    interactiveShellInit = ''
      function fish_greeting; end
      set -g theme_nerd_fonts yes
      set -g theme_color_scheme nord
      if not set -q IN_NIX_RUN
        env PF_ASCII=unset "PF_INFO=ascii title os kernel uptime pkgs memory" PF_COL3=2 pfetch
      end
      '';
    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "626bd39b002535d69e56adba5b58a1060cfb6d7b";
          sha256 = "06whihwk7cpyi3bxvvh3qqbd5560rknm88psrajvj7308slf0jfd";
        };
      }
    ];
  };

  programs.command-not-found.enable = true;

  programs.direnv = { 
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  }; 

  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    exa
    rustup
    rust-analyzer
    rnix-lsp
    vscode
    atom
    atom
    jetbrains.clion
    pigz
    tdesktop
    nushell
    pfetch
    vlc
    htop
    discord
    ripgrep
    gnome3.dconf-editor
    gnome3.gnome-tweaks
    chrome-gnome-shell
    guake
    papirus-icon-theme
    zoom-us
    firefox
    spotify
    pulseeffects-pw
    google-chrome
    brave
    noto-fonts
    opensans-ttf
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
  ];

  programs.neovim = with pkgs; neovim-cfg { package = neovim-unwrapped; plugins = vimPlugins; };

  home.file.".stack/config.yaml".text = ''
    nix:
      enable: true
      packages: [zlib.dev, zlib.out]
  '';
  
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
