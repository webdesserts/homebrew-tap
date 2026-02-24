class AuthService < Formula
  desc "OAuth 2.1 + API key authentication service for obsidian-memory"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.3.1/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "816029b5fcbe6e3838f5f86b0f76342193b31ba25ac9f0fe83827b623eb4e263"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.3.1/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "38b57828e5cf5771e4caf4373e3c084df2755e9f4ed4d7682be40122a97d766f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.3.1/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f59284106049a9b8eb1eda5e75eca3c4bec373cd1437441ea4cb1298d41ea65a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.3.1/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41c86e966da4bc3a8278f0d8bbcf43300c343de8f66a9ba6e79fec3a9fa7471c"
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
