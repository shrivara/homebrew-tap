class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.61.tar.gz"
  sha256 "2f21257452360e3a5e7265a0ce82496467b6e4172afe07e08aaffc11f8bd5b84"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.61"
    rebuild 1
    sha256 arm64_tahoe:   "8a0f08e70bcf37c758d9b53ef71d0c66c1e25c49d084bb4fbb72b4bebb2947f2"
    sha256 arm64_sequoia: "1263a47f896d4e1346f6c9d586e858b7d2a8535e0eb9975c751552b8321b22f0"
    sha256 arm64_sonoma:  "5d7d99553f23424fab3de149d5c44f7f147c5444a8e6cdf227a9af4858f95405"
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
