class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.88.tar.gz"
  sha256 "7e3d6f127db7688a02cf903df1293af43c77f3eade2b5ffbdfee6127cdf15b03"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.88"
    rebuild 1
    sha256 arm64_tahoe:   "2431421c15dc684099e31f83f646075c94f79b405841a0dffdc3a7eb79503b2f"
    sha256 arm64_sequoia: "229943617c738ff48aa6050bfb7965af2f62008be09c9b5ac68e287cbda0b2ed"
    sha256 arm64_sonoma:  "aca29bb204df66ee07f8451fd229a357d99bb03faabe43d9a3dfb888bb6104b3"
  end

  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    # SwiftPM's resource bundles must sit next to the executable. Keep the
    # complete runtime in libexec and expose only an executable wrapper in bin.
    libexec.install ".build/release/token-bar"
    libexec.install Dir[".build/release/*.bundle"]
    bin.write_exec_script libexec/"token-bar"
  end

  service do
    run [opt_bin/"token-bar"]
    process_type :interactive
  end

  def caveats
    <<~EOS
      Install and start Token Bar at login:
        brew install shrivara/tap/token-bar
        brew services start token-bar

      Update Token Bar:
        brew update
        brew upgrade token-bar
        brew services restart token-bar
    EOS
  end

  test do
    assert_predicate bin/"token-bar", :executable?
    assert_predicate libexec/"token-bar", :executable?
    assert_path_exists libexec/"token-bar_TokenBarCore.bundle/model-pricing.json"
  end
end
