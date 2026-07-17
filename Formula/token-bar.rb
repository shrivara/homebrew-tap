class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f30b96cb0c975018617c07a43a7f9cba20ecf1b7554fa475fdeb7179aa636409"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a3730d4714d2089fcb4e08baf9069f9e9f06a0993b817a468050057450956ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41965f13a8acc436b0798885d4d788cfcc1361b8ac2fdd87e54b448bd3904f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6bc5d8144551e71110706bd9ff3a3f0be1e32a67e7a12df217502533ed1e972"
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
