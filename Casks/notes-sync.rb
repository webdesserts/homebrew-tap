cask "notes-sync" do
  version "0.6.0"
  sha256 "a2e63eb90be74b96ec2903dbb346b2930aed268c9c846cb8e6168eba584980b3"

  url "https://github.com/webdesserts/notes/releases/download/v#{version}/NotesSync_#{version}_universal.dmg"
  name "NotesSync"
  desc "Desktop companion for NotesSync"
  homepage "https://github.com/webdesserts/notes"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "NotesSync.app"

  caveats <<~EOS
    NotesSync is self-signed, not Apple-notarized. On first launch, macOS may block it.
    After verifying the release, approve it once in System Settings > Privacy & Security > Open Anyway.
    Never approve an unexpected warning. An upgrade may require approval again.
    The macOS floor is a reviewed support policy, not proof on every newer macOS release.
  EOS
end
