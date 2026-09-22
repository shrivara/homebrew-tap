class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.66.tar.gz"
  sha256 "f70784fcbf7551362cf9f178fd1c69bea9d30131accfa272eda717b0aeadcd9f"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.66"
    rebuild 1
    sha256 arm64_tahoe:   "36c26350359dc4f67a700c9e76a957e432f59fa5c4f6d9329da58bfc83aef5c9"
    sha256 arm64_sequoia: "00e5d21f7f55e7db7fccb00a98caf8c3a6865845c7d911d431e3b8ef010d0df0"
    sha256 arm64_sonoma:  "d06a4961f723db9e9c16aff59f62fb46fef2e5ad0159fc68581854ae573b6f2d"
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
