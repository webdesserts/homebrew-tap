class Projects < Formula
  desc "A tool for tracking, searching for, and jumping to your projects"
  homepage "https://github.com/webdesserts/projects-cli"
  url "https://github.com/webdesserts/projects-cli.git", tag: "v1.1.1"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "projects-cli #{version}", shell_output("#{bin}/projects --version")
  end
end
