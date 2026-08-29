class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.37.tar.gz"
  sha256 "2df8751d3923f54b5d8cf69ba05587573f199e2e995235fffb78b6d84b94a928"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.37"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbc14eb4f09b7dcee5c196b1907e6580dacf0b8d111f594041fc95325c467c2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3ec2c81d14b8b5d587b5cc16fecbaebf524be285bde7679031435ab817caab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd0fe2d41e4a4da124d7f7a61ddb610e5335bd10486703a0c452a426a54369fc"
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
