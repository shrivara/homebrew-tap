class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.51.tar.gz"
  sha256 "b1b006ddb8017adf1f466ac8ee51b2936d97abfb08edd979315bdd9b8fa1efbc"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.51"
    rebuild 1
    sha256 arm64_tahoe:   "d77cd2f9388e4b064b6796b950f569cf29ab1a207006c99e9dec7b3a6c4a285d"
    sha256 arm64_sequoia: "1f54f2660cf3fa9e10cd12d64793e2df34e409d3272cf2f3ec89053ed615baae"
    sha256 arm64_sonoma:  "77f9923d67e6601001307669a1126d38586c52cec5f40941e9bf7a353c6c32e8"
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
