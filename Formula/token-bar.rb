class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.90.tar.gz"
  sha256 "6c32bce1d28edef969d1bc4b788b074c9238ddcc2b270ecebb32f6fa86b7702e"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.90"
    rebuild 1
    sha256 arm64_tahoe:   "acb2c581898b9ae242ba1ded53e2e598926b7e65f170b369ff895273f1596739"
    sha256 arm64_sequoia: "d5acafd7c8876673690779692b0f2b7c1a6e4352b74f996067d0916c3f9373e5"
    sha256 arm64_sonoma:  "1811b97ff72b85b7408fd2e1753b91127bbd83408c5ca52657d0d357f6f7db53"
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
