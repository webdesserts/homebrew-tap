cask "mesh" do
  version "0.3.0"
  sha256 "1ff397463f14b7fb7ff2e13e10ef3d02e306a615476c649394269ebac22a2d82"

  url "https://github.com/webdesserts/mesh/releases/download/v#{version}/Mesh_#{version}_universal.dmg"
  name "Mesh"
  desc "Desktop companion for Mesh"
  homepage "https://github.com/webdesserts/mesh"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Mesh.app"

  caveats <<~EOS
    Mesh is self-signed, not Apple-notarized. On first launch, macOS may block it.
    After verifying the release, approve it once in System Settings > Privacy & Security > Open Anyway.
    Never approve an unexpected warning. An upgrade may require approval again.
    The macOS floor is a reviewed support policy, not proof on every newer macOS release.
  EOS
end
