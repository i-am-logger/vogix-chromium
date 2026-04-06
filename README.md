# vogix-chromium

Privacy-hardened Chromium with runtime theme switching for [vogix](https://github.com/i-am-logger/vogix).

## What is this?

`vogix-chromium` = [ungoogled-chromium](https://github.com/nickel-org/nickel.rs) + theme switching patches from [omarchy-chromium](https://github.com/omacom-io/omarchy-chromium).

When vogix switches themes, the browser toolbar and frame colors update instantly — no restart needed.

## Features

- **Runtime theme switching** — `--set-theme-color="R,G,B"` CLI flag sends theme color to running instance via process singleton IPC
- **Policy file watcher** — writes to `/etc/chromium/policies/managed/theme.json` trigger live theme reload
- **User-level policies** — `~/.config/vogix-chromium/policies/managed/` for non-root theme switching (TODO)
- **Privacy hardened** — all ungoogled-chromium privacy patches included

## Usage with Nix

```nix
# In your flake.nix inputs:
vogix-chromium.url = "github:i-am-logger/vogix-chromium";

# In your configuration:
environment.systemPackages = [ inputs.vogix-chromium.packages.x86_64-linux.default ];
```

## Theme switching

```bash
# Via CLI (sends to running instance):
vogix-chromium --no-startup-window --set-theme-color="26,27,38"

# Via policy file (file watcher detects changes):
echo '{"ThemeColor": "#1a1b26"}' > /etc/chromium/policies/managed/theme.json
```

## Patches

| Patch | Source | Description |
|-------|--------|-------------|
| 001-omarchy-theme-switcher | omarchy-chromium | CLI flag + process singleton IPC for theme color |
| 002-omarchy-policy-reload | omarchy-chromium | Debug logging for policy theme application |
| 003-policy-theme-fixes | omarchy-chromium | Fix theme application via SetUserColor |
| 004-user-level-policy-path | vogix | User-level policy path support (TODO) |

## Build

First build takes 2-4 hours (Chromium compilation). Nix caches subsequent builds.

```bash
nix build .#
```
