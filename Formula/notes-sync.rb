class NotesSync < Formula
  desc "MCP server and CLI for an Obsidian notes vault"
  homepage "https://github.com/webdesserts/notes"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.0/notes-sync-aarch64-apple-darwin.tar.xz"
      sha256 "600b398e31b90aa0b0e50c4b5492435290e6f7589ecb52df54a7198ad1c80686"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.0/notes-sync-x86_64-apple-darwin.tar.xz"
      sha256 "ab664cebe6356f22961d7626deb518844aea3c3b7458efd98d2d28b0d4f2898c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.0/notes-sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dfd53a32f07dc42307b7dab8654b384f440b095cb950cfac8441d9e8ed918cf2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.0/notes-sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3178c9d907e48cc9e6eebc9497454739205611c21bdbbde371fc1048736d6dcb"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "notes"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "notes"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "notes"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "notes"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
