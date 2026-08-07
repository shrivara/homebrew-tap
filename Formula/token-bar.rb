class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "7dd8888679ed0bbd007bbcc984f0341a4e1565cedca724e1447bbaa9a0ede93e"
  license "MIT"

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
