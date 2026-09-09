class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.5.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/memory-aarch64-apple-darwin.tar.xz"
      sha256 "3e4d0092e12366197fc3b57ab08356de22dd8a73d5a23ac5f4fc7f76c7b5ae36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/memory-x86_64-apple-darwin.tar.xz"
      sha256 "dda20c98df3b582a771fb6b4672d3d93d17bc9f3a8c5e94d4e20dc8dbe4b2729"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ae4b02869da611deeb3db53dcc5f4463978d7db539e04908a89586a27df8477"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d26b62b1fde8706bcffbcd7f4fe3e0c112374b878509cd6237c01b14e670dd03"
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
