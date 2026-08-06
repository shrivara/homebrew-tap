class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "807e0f9409b0bdef26e11b999fbbb4f94cf3ec20afb880a85c204037ae3c8fc4"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.6"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70d676562186054ea6bf5590f642c2c921833186e977735717e09515749f0622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f9f68bcd1222d0b5889e93c1f4df83a222ffec1688008d7b001ffbe623043e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60283aeeb0ca071f038c40436e8ccc04aa9edef8b0d04fc5406ad8ec96ce9a70"
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
