class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.68.tar.gz"
  sha256 "311917c74ce919ad2de2b8a3ead638dd3584069671be2e1be8b233ae977bb612"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.68"
    rebuild 1
    sha256 arm64_tahoe:   "eac688094bb55c6b912c8f66dcfb31ff576d1dae259e38ca6d70554abbc29f3b"
    sha256 arm64_sequoia: "dc303d81a652311f41b07e74819a6c6836dfa3bb747037aeef36f0b2d121f00d"
    sha256 arm64_sonoma:  "9c166254a8c06d59f8c76464ea2b201c93b7795513ffdbb81edb8d001cc0d77b"
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
