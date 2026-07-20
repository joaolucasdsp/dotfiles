# Free Claude Code

This package and Home Manager module install
[Free Claude Code](https://github.com/Alishahryar1/free-claude-code) without
running the upstream `curl | sh` installer. The source archive, Python runtime,
and Python dependencies are all fixed by `package.nix` and `flake.lock`.

## Enable

The common profile already enables the module, so every configured machine gets
the package after:

```sh
home-manager switch --flake .#wsl
```

For a profile that imports only the module, enable it with:

```nix
programs.free-claude-code.enable = true;
```

This installs `fcc-server`, `fcc-init`, `fcc-claude`, `fcc-codex`, and `fcc-pi`
on the Home Manager profile's `PATH`. Start the proxy with `fcc-server`; the
client launchers require their corresponding client (`claude`, `codex`, or
`pi`) to be installed separately.

By default Home Manager owns `~/.fcc/.env` with safe, non-secret defaults. Add
non-secret configuration declaratively:

```nix
programs.free-claude-code.settings = {
  MODEL = "ollama/qwen3-coder";
  OLLAMA_BASE_URL = "http://localhost:11434";
};
```

Never put API keys in `settings`: Nix store contents are not secret. Point the
module at a dotenv file materialized at runtime by a secret manager instead:

```nix
programs.free-claude-code.configFile =
  "/run/user/1000/secrets/free-claude-code.env";
```

## Update

1. Choose an upstream commit and update `rev` in `package.nix`.
2. Download `https://github.com/Alishahryar1/free-claude-code/archive/<rev>.tar.gz`
   and update its SRI SHA-256 `hash`.
3. Update `version` if the upstream package version changed.
4. Compare `pyproject.toml` dependencies with `dependencies` and
   `pythonRelaxDeps`, then run `nix flake check` on Linux and macOS.

Normally only `rev`, `hash`, and (when released) `version` change. Dependency
edits are needed only when upstream changes its package metadata.

## Remove

Set `programs.free-claude-code.enable = false;` (or remove the module import),
then run `home-manager switch --flake .#<profile>`. Home Manager removes the
package and its managed config link. Runtime state and logs under `~/.fcc` are
mutable application data and are intentionally not deleted automatically.

## Known limitations

- The Admin UI cannot persist changes to the default `~/.fcc/.env`, because it
  is a read-only Home Manager link. Change `settings` and rebuild, or use a
  writable external `configFile` managed by a secrets tool.
- Voice transcription extras are not packaged. The base proxy, Discord, and
  Telegram dependencies are included; local Whisper and NVIDIA Riva add large,
  platform-specific dependency sets and should be packaged as explicit options
  if needed.
- `fcc-claude`, `fcc-codex`, and `fcc-pi` are adapters, not the clients
  themselves. This module deliberately avoids the upstream installer's remote
  client installation scripts.
- The pinned nixpkgs currently supplies a few libraries just below upstream's
  conservative lower bounds. `pythonRelaxDeps` relaxes only those metadata
  checks; their concrete versions remain reproducibly pinned by `flake.lock`.
