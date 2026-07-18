class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "59a3916e4ccfe18a951e5a340961c35e8f1219a6de3922695c63454cdb7e01cb"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.3"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d41a487b432b931a1b4e0829facb9b38c376896aa96c0ce813b616627183197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98c20e2256e8f3679a5eba2501769028a8b7f094926f8c84bf60eb9f010c17aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2502e8370a2763175f729a298fb6803b894165fc8358bfc81c22c5338f8501"
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
