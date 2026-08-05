class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "f75be2869ccb596a1a3ffee84ccb50627a6ac64197761a78fa152d83aa84f449"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a7db27650f3a55f6fe98afabce27419aa2df9111a945be0b40750789b950f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "594e2975cc0d4e8d11959bc3951eb6edfd65c4d4ad72ba5d5af060cd32db7f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e3dd3fd7a180c3e109f955343cf022ca2fffcfd64c6d3e04af936bb5f116557"
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
