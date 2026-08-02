class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3390ed89c96b2458df771d44678f682dffef4f591a8ae7b83cd9102bc3b788c2"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.0"
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "071aba8c9131bb09a7953d767144877d890b6cf41542e3f48b65f9943d9bcf77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9270a4586b90fe9dbf23daee1e900e59849f35eef912bdfa7371987c10b76148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b38161d39274ba5bca9ac4990a658add87c8fda2950791dbcb6757c70f523b2"
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
