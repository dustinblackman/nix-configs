{ ... }:

{
  imports = [
    ../systems/acer-cb3-132/system.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
  ];
}
