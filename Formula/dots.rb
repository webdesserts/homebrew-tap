class Dots < Formula
  desc "CLI for managing all your dot(file)s"
  homepage "https://github.com/webdesserts/dots-cli"
  url "https://github.com/webdesserts/dots-cli.git", tag: "v0.5.4"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dots #{version}", shell_output("#{bin}/dots --version")
  end
end
