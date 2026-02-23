class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.2.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/memory-aarch64-apple-darwin.tar.xz"
      sha256 "deb8160f4aebfc2f56a6e3cb9fcdba3b86cff0958ac969bc4922ae9ce18113bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/memory-x86_64-apple-darwin.tar.xz"
      sha256 "2366f114d7b732673e5895cbb168a206774db37c3e7a242047cbae55a3c64c7b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3093f5dad5a776eed2c4ba1308adbe229fb23ae325fd4ec3e666a2429e9b4f78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d8289d0949064abd25151318cdc48d6926ea725ba1a8636642849721fc9228d"
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
    bin.install "memory" if OS.mac? && Hardware::CPU.arm?
    bin.install "memory" if OS.mac? && Hardware::CPU.intel?
    bin.install "memory" if OS.linux? && Hardware::CPU.arm?
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
