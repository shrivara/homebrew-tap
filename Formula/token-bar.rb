class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3390ed89c96b2458df771d44678f682dffef4f591a8ae7b83cd9102bc3b788c2"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.1"
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9533a86ea032519e0ee71ddef3124ca28fb7f8ac60b54b4c432f459db8586a41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7bd46897cc6d1f5dee660371498d9597c97d0ec42f241a033356c78d97e2f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51592858957b69721c83b9144cb8b335a16885fc49368b83e396ca6432f6688d"
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
    keep_alive true
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
