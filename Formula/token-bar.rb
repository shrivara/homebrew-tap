class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.83.tar.gz"
  sha256 "573979aeff4b7496eb08c6122c2f55f6338aefdcca2634eb1cdc552945cfcae8"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.83"
    rebuild 1
    sha256 arm64_tahoe:   "435858f9c88e67c0cd6f8b87ede0d6041d027d9b28184956488cde01edf94ce6"
    sha256 arm64_sequoia: "707c8ac080ab333e3a5d37632f5ee1adbaab39e2f13739150a8069b81d55328f"
    sha256 arm64_sonoma:  "1e84ad2552c2efbf4ac1f54e0420b0337ff397447ca7248f16044a8a84e60168"
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
