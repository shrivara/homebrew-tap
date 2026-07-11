class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "5f00f8c6ef1b9e105ced4f12780e395ea3c8dd678b0c2ccb782e10141768b168"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.6.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87bf46ad69f72f9417d49216d259a98d43a70d2f390b9793faa6ab15287428ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5681336b0640f5b64245aa72da401d060a11ce0aa002e10d116bd68b201a500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe7d09d76f25bface53c9dad43184a4b89a41339d66b6babe8f0d5a02d3234f"
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
