class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.54.tar.gz"
  sha256 "b6b82761c9b5f1a67fb6975bb7d2e74b832b27da7adf395ac6a8acdba8f5be72"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.54"
    rebuild 1
    sha256 arm64_tahoe:   "1c8acec3afc0ed04d4b583f40c29992030d1687220042f3290b76b796736c7b3"
    sha256 arm64_sequoia: "70c73256425a8a09236e5b9e7381b9e2b30080f35b35ccdbec942e29886543ec"
    sha256 arm64_sonoma:  "90a2c53326a52438bd2ef28dce055ebd64380eb705b5c8b5d311f6f9717b927f"
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
