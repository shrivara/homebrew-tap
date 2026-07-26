class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "28e0a806b7d7fa3d1c22198a583014c25cc410bd541bf9df358a906c492c95b9"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.6"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d98ca2bd253feb3ff2e358537cc01ff2ddc323e4f0785a1bf62d27429da62bcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddbee29a1964457a89fa22d1026fde288def37c590fd77dbcb6ac240e8bbc2df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc7b1675afaa2f966dc84d0cedabd4e3896bcacff147beca943d1905cf866274"
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
