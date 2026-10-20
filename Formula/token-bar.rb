class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.94.tar.gz"
  sha256 "77d00158314bd0e36b4f00d0a4dded34081d306eef432e6d0087928a528098eb"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.94"
    rebuild 1
    sha256 arm64_tahoe:   "267fe26e9ea80be57de9b27c115979b2ea2493d8a02d61a2c6b3bf7ca25ee52f"
    sha256 arm64_sequoia: "0505737d506e74bbff379c5b4ff3528558e40b518a271304075e91b75a0b5cbc"
    sha256 arm64_sonoma:  "179fb91f48d32b884cd368b6671d4864e7fdfcb67cb90c443945c05dc7043a38"
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
