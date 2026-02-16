class SyncDaemon < Formula
  desc "The sync-daemon application"
  version "0.2.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.20/sync-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "143e61a41a93f8fcaa52801165b7bd41ef451bf6f7cb382282a854fcf324db96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.20/sync-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "b8e63f3c6c691dd876554c58bd2a1801b819273f9d2fe7fa0e6a4f19eee709b0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.20/sync-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf7b271fa959caba8ff3dba59fb8719d8d30cc6cc0d33786ecd100e6666c3833"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.20/sync-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f106d264f4581948392ba58e5469d0b045dbdc85f8592b660d81a1157a7179b7"
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
    bin.install "sync-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "sync-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "sync-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "sync-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
