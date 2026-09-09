class AuthService < Formula
  desc "API key authentication service for obsidian-memory"
  version "0.5.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "89f66e70857e33e58b21003c43a1aadc42b24b46c54b73a403b2ba5dd3454bea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "9cd605def58baaf62f05c1d8b70808497d6b7fe841dccdeb7dc4cf9f9128c761"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f6f8d31ba3c29534de78d0fa0ab2414659f3eda2482ce30d76acfeb30d24f8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.7/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "26aa62b87d2d6f9a4cdff83bb088c554609a308e21603cd5ad5c9649010b3b67"
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
