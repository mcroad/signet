{ config, pkgs, ... }:
 let
  # Custom packages
  nodeinfo = (import pkgs/nodeinfo.nix);
  lightning-charge = import pkgs/lightning-charge.nix { inherit pkgs; };
  nanopos = import pkgs/nanopos.nix { inherit pkgs; };
  spark-wallet = import pkgs/spark-wallet.nix  { inherit pkgs; };
  liquidd = import pkgs/liquidd.nix;
in {
  imports =
    [
      ./modules/nixbitcoin.nix
    ];
  # Turn off binary cache by setting binaryCaches to empty list
  # nix.binaryCaches = [];
  nixpkgs.config.packageOverrides = pkgs: {
    inherit nodeinfo;
    inherit lightning-charge;
    inherit nanopos;
    inherit spark-wallet;
    liquidd = (pkgs.callPackage liquidd { });
  };

  time.timeZone = "UTC";
  services.openssh.enable = true;
  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    vim tmux
    htop
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}