class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.62.tar.gz"
  sha256 "08e56cfc0096fa5ba11ccf294135ceb2cb46febfd664eedb957c90bc98b8568e"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.62"
    rebuild 1
    sha256 arm64_tahoe:   "47637b7175491e08dcb108f9b300ef308c74dcc07ff00364e3f04acc04bf3fb7"
    sha256 arm64_sequoia: "032ede2178d06a50f90eb7b7c791057573117fb781eea1083c0adb6eee67e2d1"
    sha256 arm64_sonoma:  "96e0eff1ddb648b8fbaaad07b052a475451f55a878b7a2a9b2cd13f197d7d810"
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
