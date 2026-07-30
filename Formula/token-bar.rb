class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "5ed08d0abad23f23cd204665d0d833e179614b7fc7348bb326291f4c675207e7"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.7"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f44728972e0d15e87527dbb3c9d733102b91d6dadef325f0f665f53821ffd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca46f8a46297cece2bf87c6a7dabe547478aad3b3995a59a961bbf01e82227f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e415807066639fc230644f8442fde883b83ec946184da618e4f30a788b32db5e"
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
