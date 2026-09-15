class Memory < Formula
  desc "MCP server for Obsidian memory integration with Claude"
  homepage "https://github.com/webdesserts/obsidian-memory"
  version "0.5.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/memory-aarch64-apple-darwin.tar.xz"
      sha256 "1c86dc57dbbd65acf21033fcd077e86c642c69e70e0698f4ff560355d6cd8c6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/memory-x86_64-apple-darwin.tar.xz"
      sha256 "e6bd0336bcf28b09fcf4ac42bb11fd9fbec3add262f4e0e4c4a403aa33150e87"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "90fa605f40050adc55c960bfe2c851d628403bccfea8351e17e598bba5fcf194"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9be0ea060569f912edb2792b1709ad431cd212ebc2cf1518c324383c05f081f"
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
