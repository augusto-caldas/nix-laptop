{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.zfs.requestEncryptionCredentials = true;

  fileSystems."/" =
    { device = "tear/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6865-EB53";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "tear/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "tear/nix";
      fsType = "zfs";
    };

  fileSystems."/tmp" =
    { device = "tear/tmp";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/zvol/tear/swap"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
