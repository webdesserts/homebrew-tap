cask "notes-sync" do
  version "0.6.3"
  sha256 "951d779e81dd60a998f1535f1ad51276240341af1a6d2f550c4c1952f42ac4f1"

  url "https://github.com/webdesserts/notes/releases/download/v#{version}/NotesSync_#{version}_universal.dmg"
  name "NotesSync"
  desc "Desktop companion for NotesSync"
  homepage "https://github.com/webdesserts/notes"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "NotesSync.app"
  binary "#{appdir}/NotesSync.app/Contents/MacOS/desktop", target: "notes"

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.provenance", "{{appdir}}/NotesSync.app"],
        must_succeed: false,
        print_stderr: false
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/NotesSync.app"],
        must_succeed: false,
        print_stderr: false
  end

  caveats <<~EOS
    NotesSync is self-signed, not Apple-notarized. Homebrew clears com.apple.provenance
    and quarantine in postflight_steps so the bundle does not stall at launch. If
    macOS still prompts on first launch, verify the release and approve it once in
    System Settings > Privacy & Security > Open Anyway.
    Never approve an unexpected warning.
    The macOS floor is a reviewed support policy, not proof on every newer macOS release.
  EOS
end
