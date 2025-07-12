{ config, pkgs, ... }:

{
  home-manager.users.somya = {
    home.stateVersion = "24.05";  # Required!

    home.packages = with pkgs; [
      git
    ];

    programs.git = {
      enable = true;
      userName = "sSomya123";
      userEmail = "technologyindiatechnologyindia@gmail.com";
    };
  };
}

