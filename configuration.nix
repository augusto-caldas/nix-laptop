{ config, pkgs, lib, ... }:
let
 
  # The main hostname of the system
  # Also used for network ID
  hostName = "faron";

  # List of the unfree packages needed
  unfreePackages = with pkgs; [
    mongodb-compass
    (pkgs.discord.override {
      withVencord = true;
    })
    spotify
    jetbrains-toolbox
    zoom-us
    # Driver for printing
    brgenml1lpr
    # Installing steam and steam-run
    steam
    steam-run
    steamPackages.steam
  ];

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set boot animation
  boot.plymouth.enable = true;
  boot.initrd = {
    systemd.enable = true;
    verbose = false;
  };
  boot.kernelParams = [ "quiet" "splash" ];
  boot.consoleLogLevel = 0;

  # Define your hostname
  networking.hostName = hostName;
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha512" hostName);

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";

  # Enable libvirtd
  virtualisation.libvirtd.enable = true;
  
  # Setup docker
  virtualisation.docker.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Install custom CA certificate
  security.pki.certificateFiles = [ ./ca.pem ];
  environment.sessionVariables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    SYSTEM_CERTIFICATE_PATH = "/etc/ssl/certs/ca-bundle.crt";
  };

  # Set your time zone.
  time.timeZone = "Europe/Dublin";
 
  # Enable printing
  services.printing = {
    enable = true;
    browsing = true;
    logLevel = "debug";
    # Extra configuration
    browsedConf = "
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols All
      BrowseRemoteProtocols All
      BrowseProtocols All
      CreateIPPPrinterQueues All
      CreateIPPPrinterQueues driverless
    ";
    # Setting drivers from list
    drivers = with pkgs; [
      cups-zj-58
      brlaser
      gutenprint
    ] ++ (if pkgs.stdenv.hostPlatform.isx86_64 then [
      gutenprintBin
    ] else []) ++ (if (!pkgs.stdenv.hostPlatform.isAarch) then [
      brgenml1lpr
      brgenml1cupswrapper
    ]  else []);
  };

  # Enable sound
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;
  nixpkgs.config.pulseaudio = true;
  
  # Graphical Interface
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Setup fish shell
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];

  # Define a user account
  users.users.lakituen = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "docker" "libvirtd" "kvm"
      "video" "audio"
      "plugdev"
      "scanner" "lp"
      "networkmanager" "wireshark"
      "adbusers"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [

      # GUI applications
      chromium
      cura
      drawio
      gimp
      jellyfin-media-player
      kdenlive
      krita
      libreoffice
      mpv
      mysql-workbench
      nextcloud-client
      obs-studio
      thunderbird
      tor-browser
      virt-manager
      vlc
      wireshark
      moonlight-qt

      # Terminal applications
      kitty
      docker-compose
      mongosh
      mysql-shell
      speedtest-cli

      # Editors / IDEs
      neovim

      # Compilers / Interpreters / Runtime
      android-tools scrcpy		# Android
      arduino micronucleus		# Arduino
      cmake gcc 			# C
      cargo rustc 			# Rust
      jdk spring-boot-cli gradle maven	# Java
      nodejs 				# Javascript
      python3 				# Python

      # Gnome Applications
      gnome.cheese
      gnome-decoder
      drawing
      eyedropper
      emblem
      fragments
      komikku
      gnome.gnome-tweaks
      video-trimmer

      # Others
      hunspellDicts.en-gb-ise # Spellcheck for libreoffice
    ] ++ 
    # Add the unfree packages to the user
    unfreePackages;
  };
  
  # Install global packages
  environment.systemPackages = with pkgs; [
    ntfs3g
    tmux 
    git 
    htop
    wget
    tree
  ];
  
  # Set up unfree packages
  nixpkgs.config.allowUnfreePredicate = let
    packageNames = map (eachPackage: lib.getName eachPackage) unfreePackages;
  in pkgIn: builtins.elem (lib.getName pkgIn) packageNames;

  # Installed version
  system.stateVersion = "23.05";

}
