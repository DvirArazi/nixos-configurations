{ config, pkgs, ... }:


{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  system.stateVersion = "24.05";

  systemd.user.services.atuind = {
    enable = true;

    environment = {
      ATUIN_LOG = "info";
    };
    serviceConfig = {
      ExecStart = "${pkgs.atuin}/bin/atuin daemon";
    };
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IL";

  # services.xserver.desktopManager.pantheon.enable = true;
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # hardware.graphics.enable = true;
  # Configure keymap in X11

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.dvir = {
    isNormalUser = true;
    description = "dvir";
    extraGroups = [ "networkmanager" "wheel" ];
    useDefaultShell = true;
    # ignoreShellProgramCheck = true;

    # packages = with pkgs; [];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dvir = { pkgs, ... }: {
      home.stateVersion = "24.05";
      programs = {
        atuin.enable = true;
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          plugins = [
            {
              # A prompt will appear the first time to configure it properly
              # make sure to select MesloLGS NF as the font in Konsole
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
              name = "fzf-tab";
              src = pkgs.fetchFromGitHub {
                owner = "Aloxaf";
                repo = "fzf-tab";
                rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
                sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
              };
            }
          ];
        };
      };
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    SDL2
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "dvir";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    protonup-qt
    zsh-powerlevel10k
    any-nix-shell
    google-chrome
    github-desktop
    nixpkgs-fmt
    vscode
    fd
    wget
    vlc
    git
    nixd
    nil
    steam-run
    fzf
  ];

  services.openssh.enable = true;
}
