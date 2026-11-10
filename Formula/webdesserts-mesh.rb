class WebdessertsMesh < Formula
  desc "Peer-to-peer mesh daemon and relay for WebDesserts devices"
  homepage "https://github.com/webdesserts/mesh"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/mesh/releases/download/v0.3.0/webdesserts-mesh-aarch64-apple-darwin.tar.xz"
      sha256 "bc70c7259991bc06558a44e9cf80e692f8390cff5da9c9d24e2d5ed6d597bd0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/mesh/releases/download/v0.3.0/webdesserts-mesh-x86_64-apple-darwin.tar.xz"
      sha256 "e3d15b9657426a03bff16487dd97d26d771890dc1a7e78aeb896f294010489fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/mesh/releases/download/v0.3.0/webdesserts-mesh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aaa34565c834ab2ec6d859c1d891bbe666f59dc19b5f53037b25d464b441bf41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/mesh/releases/download/v0.3.0/webdesserts-mesh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7004828f1825a1c487f874329037081c14803cf647ceae8c1dba105c1af588f"
    end
  end

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
      bin.install "webdesserts-mesh"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "webdesserts-mesh"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "webdesserts-mesh"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "webdesserts-mesh"
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
