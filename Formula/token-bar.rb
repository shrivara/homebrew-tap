class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "23a463379fa915096ca791a0a0563709b6c53803071f4220eb1ded4c22f42e60"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.4.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26704e51daf0d0c69a267a26e9dffe90328c0d5ea3af20177df18644b019f1d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc11811c42c8a2e6c649716a4c6bc6f89851c4b897d9fd3ee40dab150f2b31d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4b0988603f0dd159fe497e6fa7ab5ab2f5551bea88cb940e4cb7867db028ab"
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
