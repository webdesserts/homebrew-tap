class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.1/memory-aarch64-apple-darwin.tar.xz"
      sha256 "a18421d809d9ffe43b9fe811c7c9cff476c1bd3a3754413eb3abd7e3272cf0bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.1/memory-x86_64-apple-darwin.tar.xz"
      sha256 "7918d94fd027bdb4a4de47ac6d6526882eb7a00086a1255b9e8fc49bff842090"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.1/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90a5dba31ab90f940e3e561e35b42a29d15ca3a63647df22a8302f02e1921778"
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
