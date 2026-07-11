class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c87ca74de607d265c573d208aa9f31e8f7eaf3fe4cacd0546ec2c1fb898d947c"
  license "MIT"


  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/token-bar"
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
