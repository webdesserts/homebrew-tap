class AuthService < Formula
  desc "API key authentication service for obsidian-memory"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "8d9624941111c3225ced7d624378c09bb62aba1b5eaaed3e8e1ddb74d525d2f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "85358060a42cd6b1e0a46ee33b65cb378d18b840e94c840c4db0ec69a342d227"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8abada83fc876c9d01f747334f910cdac5472eb69c5f11cad5039cd20b122609"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.5/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5244ad75c8fa81b36312fd72a53e4eafc7f2e0b49e17d0eab2462171865706d0"
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
