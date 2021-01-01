{ pkgs }: rec {
  username = "dustin";
  # TODO Should add sizes
  # TODO should add terminal/monospace config.
  systemFont = {
    package = pkgs.roboto;
    name = "Roboto";
  };
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
  theme = {
    package = import ./qogir-theme { inherit pkgs; };
    name = "Qogir-dark";
  };
  plymouthTheme = "circle_hud";
  shellTheme = "base16_seti";
}
