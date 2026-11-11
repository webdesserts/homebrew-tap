# Homebrew Tap

Homebrew formulae and private casks for webdesserts projects.

## Formula installation

```sh
brew tap webdesserts/tap
brew install <formula>
```

## Desktop apps (single cask each)

`Mesh.app` and `NotesSync.app` ship **only** as casks. Each cask installs the app bundle and links its command-line interface out of the bundle, so there is no separate formula:

| Cask | App | CLI on `PATH` |
| --- | --- | --- |
| `webdesserts/tap/mesh` | `Mesh.app` | `webdesserts-mesh` → `Mesh.app/Contents/MacOS/Mesh` |
| `webdesserts/tap/notes-sync` | `NotesSync.app` | `notes` → `NotesSync.app/Contents/MacOS/desktop` |

```sh
brew install --cask webdesserts/tap/mesh
brew install --cask webdesserts/tap/notes-sync
```

The app detects the CLI name it was invoked as (`argv[0]`) and runs the CLI instead of the menu-bar app. The former `webdesserts-mesh` and `notes-sync` formulae are retired. If you installed them, uninstall them before installing the casks: `brew uninstall --formula webdesserts-mesh notes-sync`.

Both apps are universal (`x86_64` + `arm64`) and declare conservative macOS support floors (macOS Ventura for `mesh`, macOS Sonoma for `notes-sync`). Those floors are reviewed support policies, not proof that every newer macOS release works. NotesSync needs an already configured installation or owner-assisted vault setup before first launch. Settings and vault data are preserved, and legacy settings are migrated to `~/.config/notes/`. See the [NotesSync desktop guide](https://github.com/webdesserts/notes/blob/main/crates/desktop/README.md).

## Trust and first launch

Both apps are signed with the project's stable self-signed identity and are not Apple notarized. The casks' `postflight_steps` clear `com.apple.provenance` and `com.apple.quarantine` from the installed bundle so it does not stall at launch. If macOS still prompts on first launch, verify the release and checksum, then approve it once in **System Settings → Privacy & Security → Open Anyway**. Never approve an unexpected warning.

Replacing the signing certificate changes the trust identity. It requires new validation and may require new user approval. See the [recovery guide](https://github.com/webdesserts/notes/blob/main/crates/desktop/README.md#recovery).

## Updates

Both casks declare `auto_updates true`. Each app updates itself through its signed `tauri-plugin-updater` feed (tray → **Check for Updates**), so `brew upgrade` skips them by default. To force a cask upgrade:

```sh
brew update
brew upgrade --cask --greedy webdesserts/tap/mesh webdesserts/tap/notes-sync
```

Each app runs under its own LaunchAgent (`com.webdesserts.mesh`, `com.webdesserts.notes-sync`) and relaunches through launchd after an update.
