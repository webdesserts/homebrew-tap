class SyncDaemon < Formula
  desc "The sync-daemon application"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.7/sync-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "16dffc8aeeda2d297420a897ef6343184c118b27ddbdabcfb4001da728d6f8e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.7/sync-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "411e1320ee0b195a29f85ac00f520e625120390ced9c14f65e80bf28521328de"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.7/sync-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3370c3ab41199b6b98ddba26851f0dd3cc2f9379e76cbf1f267b4667362ef14f"
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
