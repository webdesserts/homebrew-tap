class AuthService < Formula
  desc "OAuth 2.1 + API key authentication service for obsidian-memory"
  version "0.2.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.23/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "17305678c5c8d6d738505b9a493c6f105a31a5cdc58f6d43a0da883914e1a8ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.23/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "b41bccb357018aa36f60a46d2323e9418c4f523ca2390079304373114072dccd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.23/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81f15b7445c530f708e763839b719b3007bce823861155124a8247cc6132bbd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.23/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e9938efd94e6cfba6df8f82fff25b1600ad60e5b06cb67808ac57a1bdaa8012"
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
    bin.install "auth-service" if OS.mac? && Hardware::CPU.arm?
    bin.install "auth-service" if OS.mac? && Hardware::CPU.intel?
    bin.install "auth-service" if OS.linux? && Hardware::CPU.arm?
    bin.install "auth-service" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
