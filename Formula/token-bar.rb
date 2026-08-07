class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "7dd8888679ed0bbd007bbcc984f0341a4e1565cedca724e1447bbaa9a0ede93e"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.7"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "216dde7096258c01ffb4459a8a405f74e7b7f1953cb56f91f6969788e3ab3b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b97c6964601ed4ccf938c36791e3524eb1398d68192be9e1ac206076b326b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311637ebb6800699b5103ec1beb4718e48812154e5f0ee0ab5c1f5a28a361e72"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/token-bar"
    # SwiftPM emits resource bundles (pricing catalog, provider glyphs) that
    # Bundle.module loads at runtime; they must sit next to the executable.
    bin.install Dir[".build/release/*.bundle"]
  end

  service do
    run [opt_bin/"token-bar"]
    process_type :interactive
  end

  def caveats
    <<~EOS
      token-bar is a menu bar app. Start it now and at every login with:
        brew services start token-bar
    EOS
  end

  test do
    assert_match "TOTAL", shell_output("#{bin}/token-bar --print")
  end
end
