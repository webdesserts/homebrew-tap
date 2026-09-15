class AuthService < Formula
  desc "API key authentication service for obsidian-memory"
  version "0.5.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "58100b646deaaa5ef2452100f256af32bdabf493ad43071b4db7f1c405716846"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "1c507fa15b636127d51ef69c4307446fa3993123e11664b30f605212d35857ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d33bbf90845ad6700084d3e585a30af2e6f293a871ece4c82e1809c827d3a5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.8/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8d0e42e4754916b2f6ee0acc7ad370a094bbaac385da9f12a1f02fd3080425c"
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
      bin.install "auth-service"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "auth-service"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "auth-service"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "auth-service"
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
