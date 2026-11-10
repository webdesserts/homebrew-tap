cask "notes-sync" do
  version "0.6.2"
  sha256 "9745a8327da81eab3bc0c77892e84076f6b80947b4bbfa2e8696aa9a24849fd5"

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
