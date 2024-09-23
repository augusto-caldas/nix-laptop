{ config, pkgs, lib, ... }:
let
 
  # The main hostname of the system
  # Also used for network ID
  hostName = "faron";

  # List of the unfree packages needed
  unfreePackages = with pkgs; [

    # Applications
    spotify
    zoom-us

    # Development tools
    mongodb-compass	# Database
    jetbrains-toolbox	# IDEs
    
    # Steam
    steam
    steam-run
    steamPackages.steam
    
    # Drivers
    brgenml1lpr

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

  # Enable ssh server
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };
  systemd.services = {
    sshd = {
      wantedBy = lib.mkForce [];
      restartTriggers = lib.mkForce [];
    };
  };
  networking.firewall.allowedTCPPorts = [22];

  # Enable steam
  programs.steam = {
    enable = true;
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

      # Applications
      cura
      chromium
      drawing
      drawio
      evolution
      eyedropper
      emblem
      feishin
      firefox
      fragments
      gimp
      gnome.cheese
      gnome-decoder
      gnome.gnome-tweaks
      jellyfin-media-player
      joplin-desktop
      kdenlive
      krita
      komikku
      libreoffice
      mpv
      mysql-workbench
      nextcloud-client
      obs-studio
      vesktop
      video-trimmer
      virt-manager
      vlc
      moonlight-qt

      # Development tools
      android-tools scrcpy			# Android
      arduino micronucleus			# Arduino
      cmake gcc 				# C
      mysql-workbench mysql-shell mongosh	# Database
      docker-compose				# Docker
      neovim vscodium				# Editors
      binwalk gcc-arm-embedded qemu		# Embedded
      texliveFull texstudio			# LaTeX
      insomnia wireshark			# Network
      cargo rustc 				# Rust
      jdk gradle maven				# Java
      nodejs 					# Javascript
      python3 					# Python

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
