class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "3517d78d66d548db0e40231d5645b66b6fab846eea3b35d1d5ae3c575f7d9327"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0332f94b0dc28e85e44df7d91ea68f4f1b94ffc8b92ddf40b4669215e06216b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da1d19728cc11f63cb84536683007f0f16b380b0a6324036213236c9006e766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935caf738f016f9c8cbbdcd4b3eacb7a2f0144b834821bd69796f65ff94b5070"
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
