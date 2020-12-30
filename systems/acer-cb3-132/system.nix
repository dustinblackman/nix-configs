{ config, pkgs, ... }:

let
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

  pactlCmd = command:
    let
      res = "/run/current-system/sw/bin/runuser -l $(ls /home) -c 'pactl -s unix:/run/user/1000/pulse/native ${command}'";
    in
    res;
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

  networking.networkmanager.enable = true;

  programs.light.enable = true;

  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 65 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 64 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 66 ]; events = [ "key" ]; command = "${pactlCmd "set-sink-mute 0 toggle"}"; }
      { keys = [ 67 ]; events = [ "key" ]; command = "${pactlCmd "set-sink-volume 0 -10%"} && ${pactlCmd "set-sink-mute 0 0"}"; }
      { keys = [ 68 ]; events = [ "key" ]; command = "${pactlCmd "set-sink-volume 0 +10%"} && ${pactlCmd "set-sink-mute 0 0"}"; }
    ];
  };
  services.xserver.libinput.enable = true;

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
