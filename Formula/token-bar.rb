class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "13a6012a26287388d0294d9e14596f5c1f9507b9572e43a6820a5381f938e409"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.6.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6daaa9802f409996cd27808e49e5cde530cff38958bd1af7f3aa3323312b2410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4f25b4433fc4a518fa3de11dd3eb5fafb41a4ab5cc29e3f6221036c20debeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62f1eb08836dd72787a9bb775912510e88f9623608d59d0fbe7c3795b748dbe"
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
