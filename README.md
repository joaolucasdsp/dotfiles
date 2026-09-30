# Dotfiles

Personal dotfiles managed with Nix flakes and Home Manager, for WSL, Fedora,
Omarchy (Arch + Hyprland) and macOS.

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

From Omarchy:

```sh
git clone git@github.com:joaolucasdp/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix build .#homeConfigurations.omarchy.activationPackage
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
nix build .#homeConfigurations.<profile>.activationPackage
./result/activate
```

The `rb` shell alias runs the same build and activation flow for the current profile.

## Validate

```sh
nix fmt
nix flake check
```

`nix flake check` builds the Home Manager activation package of every profile
for the current system through the configured flake checks.

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

## Layout

- `flake.nix` declares the profiles; `lib/` holds `mkHome`, which builds each
  one from `home-configurations/<name>`.
- `home-configurations/common` is shared by every profile; `linux` adds the
  Linux-only shell bits and is the base of `wsl`, `fedora` and `omarchy`.
- `modules/` holds one Home Manager module per program or concern.
- `templates/` are `nix flake init` templates; `devshells/` are standalone
  flakes for specific projects.
- `secrets/` holds sops-encrypted secrets (see `.sops.yaml`).

## Notes

- SSH and Git commit signing go through the Proton Pass SSH agent
  (`modules/ssh.nix`), linked at `~/.ssh/proton-pass-agent.sock`.
- On WSL and Fedora, `modules/proton-pass-login.nix` restores the `pass-cli`
  session from a sops-encrypted personal access token. Omarchy stores the
  session key in gnome-keyring instead (`PROTON_PASS_LINUX_KEYRING=dbus`), so it
  survives reboots after a single `pass-cli login`.
- The Fedora profile ships the Proton suite (`modules/proton.nix`): VPN, Pass,
  Mail/Calendar and Authenticator.
- Proton VPN drives the host NetworkManager over D-Bus, so it needs
  `NetworkManager` running on the Fedora side; Nix only provides the client.
- On Omarchy, Hyprland, the bar, notifications and theming stay with Omarchy;
  the profile only adds the shell/editor tooling and rofi.
