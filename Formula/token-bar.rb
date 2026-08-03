class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "76be95524886471994c7a097899d5a7a79b29ac993aafc3681ec62d6e93ff26e"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc15413d6be579fb4dad9e9f39a99f6155915c5d435797141aeb6d5068b772d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e6cf28690d0d8e4d7617829173f656d594a169f2310fef076c2581980aaeef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12776daae871f9cec361cc6a20957722a5f1ad6aec282f643e5cf0b6839fde3e"
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
