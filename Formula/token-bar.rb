class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "2e5c08e1608bbb626cb1e0fc8638b3155d96b79101637cf2b9da091d7b3284b0"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5a9e4979156c04c9db84d5eee6f9700effcec17bc117a04ad3a204dfdb40e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ce614311b7b875dbc9c63563fc7af001982132fd713808263b84ccd6560d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d6cd276b9bea4677ed84fe92217a1cf2260cfa8ac1c1b413526e58cd6e28ae"
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
