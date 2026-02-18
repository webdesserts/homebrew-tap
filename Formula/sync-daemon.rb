class SyncDaemon < Formula
  desc "The sync-daemon application"
  version "0.2.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.22/sync-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "26e7998ae6070a7211cd5619ffb6e3ec9cfddc66765328fba9a07a536ccc829f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.22/sync-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "fade63f7c13bb0cf412496e17f86faf35ce9c3b7b607efe7547b9457294fe976"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.22/sync-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46020b6b68f3f27b9029aeb45b2a464dbf2b12e9b4af743fd36cd4e755c09bd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.22/sync-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50cf75308e936be5822999ec5bf7bdf0340fd5d177c4958853193f437099c9dd"
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
