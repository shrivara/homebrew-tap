class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "715ed7b6c2ca4fdf41ac47ecb37b84e00e3826b60cf972b0bfb3bc4dc69ab1a0"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bcac06951dd227cf2df4e185577972c395586bfb4985737a1e095bdd6ee5432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619acea5f237555477ccc7fa8861b1ba7093690aa2ffaaf04440555c44c63430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06a2e5fd2a04168c417ca1a4cee765fc3975b62b3108954d5c67b9a18f567019"
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
