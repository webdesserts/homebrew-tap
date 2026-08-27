class AuthService < Formula
  desc "API key authentication service for obsidian-memory"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.2/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "13dc81372f58d0f728ad66d887fc5d1e1dcd2b461501dbafaae313894e7b0913"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.2/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "f14f05368cf718d2ba946757f260f5912e57647a7a78e6b7b412dc546cb4407b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.2/auth-service-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4df36d07adfd7c2330ffea5ba53a9b9facaf38b656b20ccb43ad11f923c6c2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.5.2/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5303921d92eae8a739609c2afc53346e18083ce4dbb6289a9ba5a01646ecea4d"
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
