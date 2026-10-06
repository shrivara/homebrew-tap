class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.80.tar.gz"
  sha256 "32c547a68466850e35859781bd6071e4f0e691d0a4c6fd04da60b8cbf65c5d18"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.80"
    rebuild 1
    sha256 arm64_tahoe:   "51247152fdf2d0be296e13ad19e3f05eed5a9d01c64e8cde18fc5b3a2f9c9cd9"
    sha256 arm64_sequoia: "cbd89124d5072098a302a807343002d1e6b82bb6ce373980b5c2913bc8b7dc4a"
    sha256 arm64_sonoma:  "9fd1cca9b8065b44ac464f604340487e37ba82a68cbcdbf6f88b0755dcba1ac2"
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
