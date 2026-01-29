{
  config,
  pkgs,
  pkgs-unstable,
  nixvim,
  lib,
  inputs,
  ...
}:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true; # firmware update utility

  networking.hostName = "frieren";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings.LANGUAGE = "en_US";
  time.timeZone = "Europe/Stockholm";

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.mutableUsers = true; # TODO change me
  users.users.aniqu = {
    isNormalUser = true;
    description = "Niko";
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
  programs.steam.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/aniqu/dotfiles";
  };

  services.flatpak.enable = true;


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.aniqu = {
    # DO NOT CHANGE THIS NUMBER, EVER!
    home.stateVersion = "25.11";
    home.username = "aniqu";
    home.homeDirectory = "/home/aniqu";

    home.packages = with pkgs; [
      discord
      spotify
      zotero
      obsidian

      python3
      tldr

      git
      lf
      libqalculate
      timewarrior

      binutils # e.g., strings
      file
      unzip

      gh

      # KDE
      kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
      kdePackages.kcalc # Calculator
      kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
      kdePackages.kclock # Clock app
      kdePackages.kcolorchooser # A small utility to select a color
      kdePackages.kolourpaint # Easy-to-use paint program
      kdePackages.ksystemlog # KDE SystemLog Application
      kdePackages.sddm-kcm # Configuration module for SDDM
      kdiff3 # Compares and merges 2 or 3 files or directories
      kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
      kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
    ];

    programs.git = {
      enable = true;

      userName  = "aniqu";
      userEmail = "niko030.nk@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };


    home.sessionVariables.EDITOR = "nvim";

    programs.zsh = {
      enable = true;

      initContent = ''
      	export PATH="$HOME/.local/bin:$PATH"
      '';
    };

    programs.htop.enable = true;

    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions =
          with pkgs.vscode-extensions;
          [
	   # TODO
          ];
        userSettings = {
          # TODO
        };
        keybindings = [
	  # TODO
        ];
      };
    };
  };

  fonts.packages =
    with pkgs;
    [
      fira-code
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
    ]
    # all fonts in the nerd-fonts namespace
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    ripgrep
    nixfmt
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # lock flake registry to keep sync'd with inputs
    # (e.g., used by `nix run pkgs#name`)
    registry = {
      pkgs.flake = inputs.nixpkgs; # alias to nixpkgs
      unstable.flake = inputs.nixpkgs-unstable;
    };

    nixPath = [
      "nixpkgs=flake:pkgs"
      "unstable=flake:unstable"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  # DO NOT CHANGE THIS NUMBER, EVER!
  system.stateVersion = "25.11";
}
