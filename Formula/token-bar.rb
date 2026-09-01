class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.44.tar.gz"
  sha256 "55dd8403389676deb05062da9ed3ae6e5411f696e28882c9402ea973846bd638"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.44"
    rebuild 1
    sha256 arm64_tahoe:   "12eb314dd2398fcad7e467682c5ca4871782b7f97f0b136d6adb30fbf9e1e061"
    sha256 arm64_sequoia: "52594fc1e6a8dd7cc1e5387573f39e5806c7019e6c91127b3764e059c6f7fcdc"
    sha256 arm64_sonoma:  "844f5b77766ee6f51d73273e96f31c8e061d58a593a3cf9fffefb480eae3eeb1"
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
