{ pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.interfaces.enp0s5.useDHCP = true;
  services.openssh.enable = true;
}
