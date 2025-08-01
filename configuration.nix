{ config, pkgs, lib, ... }:
let
 
  # The main hostname of the system
  # Also used for network ID
  hostName = "faron";

  # Importing package sets
  applicationPackages = import ./packages/application-packages.nix { inherit pkgs; };
  developmentPackages = import ./packages/development-packages.nix { inherit pkgs; };
  globalPackages = import ./packages/global-packages.nix { inherit pkgs; };
  unfreePackages = import ./packages/unfree-packages.nix { inherit pkgs; };

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable firmware update
  services.fwupd.enable = true;

  # Enable thunderbolt
  services.hardware.bolt.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set boot animation
  boot.plymouth.enable = true;
  boot.initrd = {
    systemd.enable = true;
    verbose = false;
  };
  boot.kernelParams = [ "quiet" "splash" ];
  boot.consoleLogLevel = 0;

  # Lock screen when lid close
  services.logind.lidSwitch = "lock";
  services.logind.lidSwitchDocked = "lock";
  services.logind.lidSwitchExternalPower = "lock";
  
  # Define your hostname
  networking.hostName = hostName;
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha512" hostName);

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";

  # Enable libvirtd
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

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

  # Enable fingerprint
  services.fprintd.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";
 
  # Enable printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable ssh server
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
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
  services.pulseaudio.enable = false;
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
    packages = applicationPackages ++ developmentPackages ++ unfreePackages;
  };
  
  # Install global packages
  environment.systemPackages = globalPackages;
  
  # Set up unfree packages
  nixpkgs.config.allowUnfreePredicate = let
    packageNames = map (eachPackage: lib.getName eachPackage) unfreePackages;
  in pkgIn: builtins.elem (lib.getName pkgIn) packageNames;

  # Installed version
  system.stateVersion = "25.05";
}
