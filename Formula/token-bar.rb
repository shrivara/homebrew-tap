class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.49.tar.gz"
  sha256 "39877608a53ad85a0b4a3a5ec73d858e2ca6e3e515120368dfd3ed89fc675813"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.49"
    rebuild 1
    sha256 arm64_tahoe:   "1accfa0883c3dcbf4ff9c1fe0854abcf4ebb3d428e36597d74ef9ff86ab22d4f"
    sha256 arm64_sequoia: "5d80bcdc90ee573c32d7909c13326dd4348efdf6744765b3dd47954b6d245767"
    sha256 arm64_sonoma:  "46bd5716ed417194e204b36b5944992c8fe13c9b90d55c035a1b044fbce3dfb4"
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
