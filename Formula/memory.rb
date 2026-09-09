class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/memory-aarch64-apple-darwin.tar.xz"
      sha256 "b51fe3791160db72e6412f512d76465d6816a80d53eb36898c4d9be559e00d79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/memory-x86_64-apple-darwin.tar.xz"
      sha256 "93dd0ac6c733bab9af5e439ded614bdab11cefe7d897f9f975e0d656c5a56d69"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "56a338532bc4e849f40986151685e266a606f6b69bef382ad9867fa22f20c1f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3793a870392552a9f04de46ab4a4fadd15c9238fc7238a0c50be320f2a901818"
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
      bin.install "memory"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "memory"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "memory"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "memory"
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
