class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "412c5a8ba990ed463673b55e51bc774206747bdc4be807012f9067be64693d1a"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d105bafa89007909f1f4b12a5156200fbb6e8178e07bbe0ba75998a0f47439d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985fdef392ba1f6bca1226e35c9077ae174cde105f7d95ec9b2fd1a7622c02f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94991ce7b4c74461a09d998416d4a727410253ae6b460abdd978c56e13c4e6fc"
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
