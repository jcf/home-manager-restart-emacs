{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkOptionType types;
  cfg = config.my;
in {
  options = {
    my.username = mkOption {
      type = types.str;
      default = "alice";
    };
  };

  config = {
    # Must be set in order to build a multi-user system.
    services.nix-daemon.enable = true;

    # Without this, we're told attribute '$USER' is missing.
    users.users.${cfg.username} = {};

    home-manager = {
      users.${cfg.username} = {};
      sharedModules = [
        {
          # Must be present or it'll be used but not-defined.
          home.stateVersion = "23.11";
        }
      ];
    };
  };
}
