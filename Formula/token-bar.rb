class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.22.tar.gz"
  sha256 "5d113a8a7c6c2f589658c2f8213dc14a80fe8319f8988e9a3e120d6c797914e0"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.22"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d4fe1ec684d4d9803c4a02ed6c3eff9919aada2a082d34cad7dc70aac8d726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100715fd1c315846f1c17a25590dab4b0c41c6139ed9599e17c1f49c31d5cd34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8232fc76431dad65a6d322d1f368869e1ce9b6c7184ac0abdc2cf28d14003960"
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
