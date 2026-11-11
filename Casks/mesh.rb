cask "mesh" do
  version "0.3.1"
  sha256 "60fe34be117dacab8e6246ce00183d8ea3ed58322417d871617c4284df599117"

  url "https://github.com/webdesserts/mesh/releases/download/v#{version}/Mesh_#{version}_universal.dmg"
  name "Mesh"
  desc "Desktop companion for Mesh"
  homepage "https://github.com/webdesserts/mesh"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "Mesh.app"
  binary "#{appdir}/Mesh.app/Contents/MacOS/Mesh", target: "webdesserts-mesh"

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.provenance", "{{appdir}}/Mesh.app"],
        must_succeed: false,
        print_stderr: false
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Mesh.app"],
        must_succeed: false,
        print_stderr: false
  end

  caveats <<~EOS
    Mesh is self-signed, not Apple-notarized. Homebrew clears com.apple.provenance
    and quarantine in postflight_steps so the bundle does not stall at launch. If
    macOS still prompts on first launch, verify the release and approve it once in
    System Settings > Privacy & Security > Open Anyway.
    Never approve an unexpected warning.
    The macOS floor is a reviewed support policy, not proof on every newer macOS release.
  EOS
end
