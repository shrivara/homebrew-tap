class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f30b96cb0c975018617c07a43a7f9cba20ecf1b7554fa475fdeb7179aa636409"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d295d6b1b88ea6c8423028d62a3d5b5f1884880290825a792a85d5667388c98c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d07143bd0b48ede8078a283f373b625602bc1aaa76b73008d34e030409907d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4b0c5d3762656751cbf21e76f0589fffed05d6f00da0b92ffecf9916df0ddc"
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
