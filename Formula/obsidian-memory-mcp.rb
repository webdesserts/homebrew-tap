class ObsidianMemoryMcp < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.1.1/obsidian-memory-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "a33aecfa7d30efe1df749e6b0c764d9be99e43bc685ec90132c6e590810bae08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.1.1/obsidian-memory-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "351c600483d16f53f47e178af58a950ec6e0f832d272a0c8311fabeffe8daad3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.1.1/obsidian-memory-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2fab701d4e311e20c3ab176324fa2ea5b12625abc84dcbfa5383c02ab8fc5ee8"
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
