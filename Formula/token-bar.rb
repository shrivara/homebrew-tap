class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c87ca74de607d265c573d208aa9f31e8f7eaf3fe4cacd0546ec2c1fb898d947c"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.5.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9ba55f64bd6bd652cb9d7e233343a6069471396a3d58a10f5297114c7cedd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c699c5002e54f7cad7f8994223d95316c9b1acaddbc81948e86b349beb7f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2f3758c4dab0f041e2e06681633288757ff696dc51cf6b2376af7f72a14b823"
  end


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
