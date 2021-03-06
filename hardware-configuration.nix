# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  services.power-profiles-daemon.enable = true;
  services.tlp = {
    enable = false;
    settings = {
      USB_EXCLUDE_AUDIO = 1;
      RUNTIME_PM_DRIVER_BLACKLIST = "nouveau nvidia";
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
    };
  };

   services.logind.extraConfig = ''
    HandleLidSwitchDocked=suspend
  '';

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b7bbd78d-ac66-4172-b449-da2942869549";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/b7bbd78d-ac66-4172-b449-da2942869549";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.swap" =
    { device = "/dev/disk/by-uuid/b7bbd78d-ac66-4172-b449-da2942869549";
      fsType = "btrfs";
      options = [ "subvol=@swap" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/50B5-1546";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/.swap/swapfile"; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.nvidiaOptimus.disable = true;
  powerManagement.powertop.enable = true;

  # services.tlp.enable = true;
}
