class AuthService < Formula
  desc "OAuth 2.1 + API key authentication service for obsidian-memory"
  version "0.2.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.12/auth-service-aarch64-apple-darwin.tar.xz"
      sha256 "f969f3713afc95f9e60055962840d094dbec7cad99a96bdda3bc8636a3746d83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.12/auth-service-x86_64-apple-darwin.tar.xz"
      sha256 "5a0f539aaf21bd31c83c17569f65296d4093203e19c660d8ce2b4d8b4c01aefe"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/webdesserts/obsidian-memory/releases/download/v0.2.12/auth-service-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2caf66d48e2429f01bc8cdcdf4387a2b1cc07e58c70a5344870ba40fd6a36021"
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
