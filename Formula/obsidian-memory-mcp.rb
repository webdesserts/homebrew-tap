class ObsidianMemoryMcp < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.1.0/obsidian-memory-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "58b8429907ad9e72f4641ef495256a827d26e7cd1aa20518a7f9e738c2e78908"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.1.0/obsidian-memory-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "f7950749ceb89a6541c6f192ca2a9ced2bb0a050fd84af40d6db13a18730dcbd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.1.0/obsidian-memory-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9aa146b346ba7d1e129146e775444e8ad997571092babd07b14bfb34c5ac0456"
  end
  license "MIT"

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
    bin.install "obsidian-memory" if OS.mac? && Hardware::CPU.arm?
    bin.install "obsidian-memory" if OS.mac? && Hardware::CPU.intel?
    bin.install "obsidian-memory" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
