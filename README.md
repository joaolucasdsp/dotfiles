# Dotfiles

Personal WSL dotfiles managed with Nix flakes and Home Manager.

## Bootstrap

From WSL:

```sh
git clone git@github.com:joaolucasdp/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix build .#homeConfigurations.wsl.activationPackage
./result/activate
```

From Fedora:

```sh
git clone git@github.com:joaolucasdp/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix build .#homeConfigurations.fedora.activationPackage
./result/activate
```

From macOS:

```sh
git clone git@github.com:joaolucasdp/dotfiles.git ~/dotfiles
cd ~/dotfiles
home-manager switch --flake .#macos
```

The macOS profile assumes Apple Silicon (`aarch64-darwin`). For Intel Macs,
change the `macos` system in `flake.nix` to `x86_64-darwin`.

If `direnv` blocks the repository environment, approve it after reviewing `.envrc`:

```sh
direnv allow
```

## Rebuild

```sh
cd ~/dotfiles
nix build .#homeConfigurations.wsl.activationPackage
./result/activate
```

The `rb` shell alias runs the same build and activation flow.

## Validate

```sh
nix fmt
nix flake check
```

`nix flake check` builds the WSL Home Manager activation package through the configured flake checks.

## Templates

List available templates:

```sh
nix flake show ~/dotfiles
```

Initialize a template:

```sh
nix flake init -t ~/dotfiles#basic
```

For Rust projects, initialize the Nix environment first and then initialize Cargo inside the same directory:

```sh
mkdir -p ~/projects/math_eval
cd ~/projects/math_eval
nix flake init -t ~/dotfiles#rust
direnv allow
cargo init --bin --name math_eval
cargo run
```

## Notes

- Git commit signing uses SSH signing backed by the configured Bitwarden SSH agent flow.
- macOS uses the Bitwarden SSH Agent socket at `~/.bitwarden-ssh-agent.sock`.
- The WSL profile is defined in `home-configurations/wsl`.
- The macOS profile is defined in `home-configurations/macos`.
- The Fedora profile is defined in `home-configurations/fedora` and ships the
  Proton suite (`pkgs/proton.nix`): VPN, Pass, Mail/Calendar and Authenticator.
- Proton VPN drives the host NetworkManager over D-Bus, so it needs
  `NetworkManager` running on the Fedora side; Nix only provides the client.
- Reusable Home Manager modules live in `pkgs`.
