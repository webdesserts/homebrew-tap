class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.2.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.18/memory-aarch64-apple-darwin.tar.xz"
      sha256 "7f9543dba8e2596e12603a3ab640e2f1b4ad9b71edba6acee327d771fa08c9ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.18/memory-x86_64-apple-darwin.tar.xz"
      sha256 "ad90f24bf72c6c20e8aeaa4bd85a3e2a0d45e9cf9a3734d1029adf8698cd352e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.18/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bb4b5596102489a66ef4b65298901c880fe9dd973d6fcc74098ed32f6aa85303"
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
