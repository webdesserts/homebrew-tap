class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.4/memory-aarch64-apple-darwin.tar.xz"
      sha256 "0e293e19c682751a941d68f48cbcf1d487f30e8900fa573934a0343069c637c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.4/memory-x86_64-apple-darwin.tar.xz"
      sha256 "3153e63a9975936632124b67c1762c0dda83763b5454fd94890d674935df4c95"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.4/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c738fae90cd06dbc46df97982ef0f0738f9971a8d55afa09d8ca8f9a56d6f72"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "memory" if OS.mac? && Hardware::CPU.arm?
    bin.install "memory" if OS.mac? && Hardware::CPU.intel?
    bin.install "memory" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
