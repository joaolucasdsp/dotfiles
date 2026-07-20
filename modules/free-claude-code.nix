{ config, lib, pkgs, ... }:

let
  cfg = config.programs.free-claude-code;

  renderValue = value:
    if builtins.isBool value then
      (if value then "true" else "false")
    else
      toString value;

  generatedEnv = pkgs.writeText "free-claude-code.env" (
    lib.generators.toKeyValue
      {
        mkKeyValue = key: value:
          "${key}=${lib.escapeShellArg (renderValue value)}";
      }
      cfg.settings
  );

  managedEnvPath = "${config.home.homeDirectory}/.fcc/.env";
in
{
  options.programs.free-claude-code = {
    enable = lib.mkEnableOption "Free Claude Code proxy and client launchers";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../pkgs/free-claude-code { };
      defaultText = lib.literalExpression
        "pkgs.callPackage ../pkgs/free-claude-code { }";
      description = "Free Claude Code package to install.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [
        lib.types.bool
        lib.types.float
        lib.types.int
        lib.types.str
      ]);
      default = {
        ANTHROPIC_AUTH_TOKEN = "freecc";
        FCC_OPEN_BROWSER = true;
        MESSAGING_PLATFORM = "none";
        VOICE_NOTE_ENABLED = false;
      };
      description = ''
        Values rendered to the managed ~/.fcc/.env file. Do not put API keys
        here because generated Nix files are readable from the Nix store; use
        configFile with a secret manager for credentials.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/user/1000/secrets/free-claude-code.env";
      description = ''
        Optional runtime path to a complete dotenv file, typically produced by
        a secret manager. When set, Home Manager does not create ~/.fcc/.env.
      '';
    };

    environmentVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = "1";
      };
      description = "Additional session variables for Free Claude Code clients.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # FCC_ENV_FILE makes config discovery deterministic even when a command is
    # launched outside the user's home directory.
    home.sessionVariables = cfg.environmentVariables // {
      FCC_ENV_FILE = if cfg.configFile == null then managedEnvPath else cfg.configFile;
    };

    home.file.".fcc/.env" = lib.mkIf (cfg.configFile == null) {
      source = generatedEnv;
    };
  };
}
