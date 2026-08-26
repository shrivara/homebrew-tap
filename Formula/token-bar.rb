class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.33.tar.gz"
  sha256 "ebd9883fa8e99b81e6e9a7c6e1f929f14759b17ae57c2fad298db8d63005f12a"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.33"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba54fe97aa2d01e5641ef3eaf2ac07d0fcb3514abff63a8cb7f50c327570a079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afea72a198946c762c41819ca0bbb583a4b51c102d365bf04a5d61a2d58f0b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b7abd399c6d11d07f2197b6c886cceb817de911b87c291219192696fafd435"
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
