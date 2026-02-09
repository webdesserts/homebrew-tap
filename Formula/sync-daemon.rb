class SyncDaemon < Formula
  desc "The sync-daemon application"
  version "0.2.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.19/sync-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "83dc549328766fad6a53b199c9ee29f14b384df92819b86c136710cfc50729e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.19/sync-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "8980fc7753b4c5fc90e0046fddc47b0ac5ebb02bdb678c335f12bbdca1da005e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.19/sync-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94f58875e47576c21e579780fd96cde1c902fc434555f9c918d3fdaf769afcaa"
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
    bin.install "sync-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "sync-daemon" if OS.mac? && Hardware::CPU.intel?
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
