class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "0bfd282acfc3dcb46999eefba1e655c10fbef2fa94c4300d37332e9fdd30a759"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "759403b7bbdc4ce64b8e223e96b562afb13305c26b19fada206bade6ed5d4c91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9ba1ab78540b80c7bf2ff312bcbe062afc65cf64c174ac8c37bd06151acb8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b552f2fb4994bd8dd175d713b032e5a3193b4d5dbafb4aba9f27306204058f"
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
