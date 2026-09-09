class AuthService < Formula
  desc "API key authentication service for obsidian-memory"
  version "0.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "855e008f10e3ebd8748bb36d5b5098ececbd66b3ec4170be966273e2ca2f0908"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "240195f5f60e3a8a6b97bd349ac155d426adbbd39892b14c894d775c7a41abe7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96a8f32b91cc2d5822727b7073b45a1a4499277b1c44df203371bfc3b3af3cb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.6/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4ff8646c1c07b89b284b3404c2d2726d8b1f64cd3ab7b198af924ac164d5b90"
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
