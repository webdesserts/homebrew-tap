class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.3/memory-aarch64-apple-darwin.tar.xz"
      sha256 "9462d828311292458bd701fe9447e324de514bee4c44e87baf74f9185a2e9bd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.3/memory-x86_64-apple-darwin.tar.xz"
      sha256 "93163934870703f34160e8a0831a15fbc2cd8b028bff818faa8daca86a40e0fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.3/memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "755e64278b5e0558c526200495bba445a2672ac33d43a4b0d801b62163c8f4fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.3/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a78d9ddff12749b29118235d8f3827b3321021b63620aaf9e1f19bcc6c4b0db9"
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
