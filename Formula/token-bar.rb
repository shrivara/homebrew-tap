class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.40.tar.gz"
  sha256 "f21a550f0977897bc1a790451bb1e81549cb061c6c84036fdc2ada0d859c8a21"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.40"
    rebuild 1
    sha256 arm64_tahoe:   "4a4c0f9475d6f56e923471d29118483f780c2e64fa938554e508aeb495e588ae"
    sha256 arm64_sequoia: "420d01dd81f721524f45948da8557b8f46c6107705ce77083ba6e6b61c38ada1"
    sha256 arm64_sonoma:  "559a798651ed629d24abfe5ecc7e98455ff89066442d1d8a5e8f4f6dd5b9e8ff"
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
