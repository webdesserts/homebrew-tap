class AuthService < Formula
  desc "OAuth 2.1 + API key authentication service for obsidian-memory"
  version "0.2.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.16/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "2d1991bc504b0dceb5ad9271ba0b6587005fe95fb7ba74a95f2fe7d6af06f828"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.16/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "d30ca6fecadd28157430d6ecf0b7bd0df47824538620c94a2302e19bcc31e84f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.16/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62603c7a0121ad668ca674204ad368e54023649bb001696ebf4b5b052d7d58f7"
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
    bin.install "auth-service" if OS.mac? && Hardware::CPU.arm?
    bin.install "auth-service" if OS.mac? && Hardware::CPU.intel?
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
