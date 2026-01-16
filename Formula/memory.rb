class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.8/memory-aarch64-apple-darwin.tar.xz"
      sha256 "bebf13b330335e0fd1160ee2dd0e817a38af761cdf6cd98ae633782814de660a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.8/memory-x86_64-apple-darwin.tar.xz"
      sha256 "bcaa309b2d2c3835f2b00a8f73dbb4ea016181d2489f8521af5aec00c05e43dd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.8/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4894419302fe8618d64d5ad671650dd0bf31c42f58266ebe716b4b73a2d6ac7c"
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
