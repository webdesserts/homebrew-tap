class NotesSync < Formula
  desc "MCP server and CLI for an Obsidian notes vault"
  homepage "https://github.com/webdesserts/notes"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.2/notes-sync-aarch64-apple-darwin.tar.xz"
      sha256 "d1a829e0543eeac430e91638b53a87f648193092af4406480bc272a39e229754"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.2/notes-sync-x86_64-apple-darwin.tar.xz"
      sha256 "e71514f557aac9cb0624a0ab477649561ae32b004698670856c77932aa7e2959"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.2/notes-sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ff361fc0d5dd6877a465f18ee0822e64258fab92af6ca73d9177fa55fa5eff2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/webdesserts/notes/releases/download/v0.6.2/notes-sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "350061eed314c6e7322cf4a1d6f8bf782f8d04ef4f8ce867bdc3197428884f82"
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
      bin.install "notes"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "notes"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "notes"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "notes"
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
