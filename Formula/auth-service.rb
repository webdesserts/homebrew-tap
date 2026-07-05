class AuthService < Formula
  desc "OAuth 2.1 + API key authentication service for obsidian-memory"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.1/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "fc588a74e98227333de17130d1909049e9abb37563a6beee31762ce5ea6ce9e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.1/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "d3b70aa7403779836da1d3d0342da6455cc3050007c3563c888c62f8bbb14415"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.1/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d308f5605e703975b7683bfcbce96ec1c44fea76ed2f3258ddd4466b92412db9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.1/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf97b945091de5ece33f9c806497d809c5a42e550cde3d5df076d3435a028683"
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
