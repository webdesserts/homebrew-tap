cask "webdesserts-memory" do
  version "0.5.8"
  sha256 "e1306b4bba87e1297fe8c48f0b0e921d39f30f5e8e09f1dce730518a5f059b83"

  url "https://github.com/webdesserts/obsidian-memory/releases/download/v#{version}/Memory_#{version}_aarch64.dmg"
  name "Memory"
  desc "Desktop companion for Obsidian memory"
  homepage "https://github.com/webdesserts/obsidian-memory"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Memory.app"

  caveats <<~EOS
    Memory is self-signed, not Apple-notarized. On first launch, macOS may block it.
    After verifying the release, approve it once in System Settings > Privacy & Security > Open Anyway.
    Never approve an unexpected warning. An upgrade may require approval again.
    The macOS floor is a reviewed support policy, not proof on every newer macOS release.
  EOS
end
