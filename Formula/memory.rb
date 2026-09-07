class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/memory-aarch64-apple-darwin.tar.xz"
      sha256 "fe55f7c39a5e8be105fe6dcec3525a3ac5bd0c279d90e78befd5bb798d011cfd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/memory-x86_64-apple-darwin.tar.xz"
      sha256 "1878bcf48bd7ce1501328354476956603ea31eb2ea009df52bb08745661f4c71"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a77d6bee24d4a1cf86890dfdd557629936a972f86ced68df4598de0008313deb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3df11be98fee239fa8e90cff312638410de68b02790b7d1565ed70286232c925"
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
