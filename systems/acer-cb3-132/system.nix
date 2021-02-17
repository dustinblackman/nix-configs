{ config, pkgs, ... }:
let
  locals = import ../../locals.nix { inherit pkgs; };

  galliumSrc = pkgs.fetchFromGitHub {
    owner = "GalliumOS";
    repo = "linux";
    rev = "330fea63255fc7dafb0400ceded3b022554f3707";
    sha256 = "03xk8i338ahzq39nk30pzraymvckpdypmg8rrgbqi4qly6565nl4";
  };

  galliumKernel = pkgs.linuxPackages_custom {
    src = galliumSrc;
    version = "5.9.8";
    configfile = "${galliumSrc}/galliumos/config";
    allowImportFromDerivation = true;
  };
in
{
  # nixpkgs.overlays = [
  # (import ./overlays.nix)
  # ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = galliumKernel;
  boot.initrd.availableKernelModules = [ "xhci_pci" "sd_mod" "mmc_block" ];

  # Extracted from pkgs.linux_5_9, to match gallium source.
  boot.kernelPatches = with pkgs; [
    kernelPatches.bridge_stp_helper
    kernelPatches.request_key_helper
    kernelPatches.export_kernel_fpu_functions."5.3"
  ];

  security.wrappers = {
    light = {
      source = "${pkgs.light}/bin/light";
      owner = "root";
      group = "root";
    };
  };

  networking.networkmanager.enable = true;

  programs.light.enable = true;
  services.xserver.libinput.enable = true;

  home-manager.users."${locals.username}" = {
    home.file.".xbindkeysrc".source = ./xbindkeysrc;
  };

  # Laptop is too slow, use remote docker image instead. For now hardcoded to macbook.
  nix.buildMachines = [{
    hostName = "dockerbuilder";
    system = "x86_64-linux";
    maxJobs = 1;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  environment.etc."ssh/nix-docker-builder".source = ./nix-docker-builder;
  programs.ssh.extraConfig = ''
    Host dockerbuilder
      HostName 192.168.50.98
      Port 3022
      User root

      IdentitiesOnly yes
      IdentityFile ${environment.etc."ssh/nix-docker-builder".target}
  '';

  # Module listed extracted from GalliumOS 3.1.
  # TODO Find way to automate grabbing this list in the future.
  boot.blacklistedKernelModules = [
    "ac97"
    "ac97_codec"
    "ac97_plugin_ad1980"
    "ac97_plugin_wm97xx"
    "ad1816"
    "ad1848"
    "ad1889"
    "adlib_card"
    "aedsp16"
    "ali5455"
    "amd76x_edac"
    "asus_acpi"
    "ath_pci"
    "aty128fb"
    "atyfb"
    "audio"
    "awe_wave"
    "bcm43xx"
    "bochs-drm"
    "btaudio"
    "cirrusfb"
    "cmpci"
    "cs4232"
    "cs4281"
    "cs461x"
    "cs46xx"
    "cyber2000fb"
    "cyblafb"
    "de4x5"
    "dmasound_core"
    "dmasound_pmac"
    "dv1394"
    "eepro100"
    "emu10k1"
    "es1370"
    "es1371"
    "esssolo1"
    "eth1394"
    "evbug"
    "forte"
    "garmin_gps"
    "gus"
    "gx1fb"
    "harmony"
    "hgafb"
    "i2c_i801"
    "i810_audio"
    "i810fb"
    "intelfb"
    "kahlua"
    "kyrofb"
    "lxfb"
    "mad16"
    "maestro"
    "maestro3"
    "matroxfb_base"
    "maui"
    "microcode"
    "mpu401"
    "neofb"
    "nm256_audio"
    "nvidiafb"
    "ohci1394"
    "opl3"
    "opl3sa"
    "opl3sa2"
    "pas2"
    "pcspkr"
    "pm2fb"
    "prism54"
    "pss"
    "radeonfb"
    "raw1394"
    "rivafb"
    "rme96xx"
    "s1d13xxxfb"
    "savagefb"
    "sb"
    "sb_lib"
    "sbp2"
    "sequencer"
    "sgalaxy"
    "sisfb"
    "snd_aw2"
    "snd_intel8x0m"
    "snd_pcsp"
    "sonicvibes"
    "sound"
    "soundcard"
    "sscape"
    "sstfb"
    "tdfxfb"
    "trident"
    "tridentfb"
    "trix"
    "uart401"
    "uart6850"
    "udlfb"
    "usb-midi"
    "usbkbd"
    "usbmouse"
    "v_midi"
    "vfb"
    "via82cxxx_audio"
    "viafb"
    "video1394"
    "vt8623fb"
    "wavefront"
    "ymfpci"
  ];
}
