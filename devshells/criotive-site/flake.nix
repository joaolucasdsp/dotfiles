{
  description = "Ambiente de desenvolvimento do criotive/site (.NET 8 + Node + Docker)";

  # Mesmo rev de nixpkgs que o resto da máquina usa, para compartilhar closure
  # e não abrir uma segunda árvore de pacotes só para este projeto.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/0bb7ec54c8483066ec9d7720e780a5caa71f8612";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # global.json pede sdk 8.0.0 com rollForward latestFeature.
              dotnet-sdk_8
              nodejs_22
              # O docker é o do sistema (Fedora), mas ele vem sem o plugin
              # compose; este pacote entra pelo DOCKER_CONFIG do shellHook.
              docker-compose
              act # scripts/ci-local.sh
              gh # e2e/e2e.sh
              jq
            ];

            # O dotnet do nix não se acha sozinho sem DOTNET_ROOT.
            DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
            DOTNET_CLI_TELEMETRY_OPTOUT = "1";
            DOTNET_NOLOGO = "1";

            shellHook = ''
              # Os scripts do projeto chamam `docker compose` (subcomando, não
              # o binário hifenizado). O docker do Fedora não traz esse plugin,
              # então montamos um DOCKER_CONFIG próprio que continua enxergando
              # o config.json real — credenciais de registry seguem valendo — e
              # acrescenta só o diretório de plugins.
              export DOCKER_CONFIG="''${XDG_STATE_HOME:-$HOME/.local/state}/criotive-site/docker"
              mkdir -p "$DOCKER_CONFIG/cli-plugins"
              if [ -f "$HOME/.docker/config.json" ] && [ ! -e "$DOCKER_CONFIG/config.json" ]; then
                ln -s "$HOME/.docker/config.json" "$DOCKER_CONFIG/config.json"
              fi
              ln -sfn ${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose \
                "$DOCKER_CONFIG/cli-plugins/docker-compose"

              echo "criotive/site: dotnet $(dotnet --version), node $(node --version)"
            '';
          };
        }
      );
    };
}
