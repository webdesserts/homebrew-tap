# Homebrew Tap

Homebrew formulae and private casks for webdesserts projects.

## Formula installation

```sh
brew tap webdesserts/tap
brew install <formula>
```

## Memory Desktop

Memory Desktop is an arm64, menu-bar companion for Obsidian Memory. Its cask
declares macOS Tahoe as a conservative support floor. This release requires an
already configured installation or owner-assisted vault setup before first
launch; it does not provide first-run vault selection. Preserve existing
settings and vault data. See the
[desktop guide](https://github.com/webdesserts/obsidian-memory/blob/main/crates/desktop/README.md) for the persisted-settings prerequisite and operational details.

```sh
brew install --cask webdesserts/tap/webdesserts-memory
```

Memory is signed with the project's stable self-signed identity and is not Apple
notarized. After verifying the intended release and checksum, first launch may
require **System Settings → Privacy & Security → Open Anyway**. Approve only the
expected unverified-developer warning for Memory. Do not remove quarantine,
disable Gatekeeper, install a custom trust policy or bypass an unexpected
warning.

Updates are explicit:

```sh
brew update
brew upgrade --cask webdesserts/tap/webdesserts-memory
```

A same-signer 0.5.7 → 0.5.8 smoke on macOS 26.6.2 retained quarantine and
launched normally without a second blocking approval. This is one host's
observation, not a promise that approval persists across every host or release.
Memory does not restart automatically after an upgrade; quit before upgrading,
then relaunch it from Applications or Spotlight.

For recovery and publisher-identity rotation expectations, see the authoritative
[desktop install and recovery guide](https://github.com/webdesserts/obsidian-memory/blob/main/crates/desktop/README.md#recovery). Replacing the signing certificate is a trust-identity change that requires new validation and may require new user approval.
