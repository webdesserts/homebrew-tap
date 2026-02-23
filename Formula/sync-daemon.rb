class SyncDaemon < Formula
  desc "The sync-daemon application"
  version "0.2.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/sync-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "9dc4d91b85db809dd0ac3852ef6c25c22c9317c7380f51aa145432a4c803890a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/sync-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "499d8bb08ef60c34abc534a8a338ee4865d7e4755eb3d68ce346436fd33ebdc7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/sync-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "de46a25f29ddb0d34aacc2f4eb977671a0fda6b74636b903228dbe9571ee74b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.24/sync-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13225d22528d58a1d53589a6d4835dfd73f51a14788abd9bf516802a4314a1f6"
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
