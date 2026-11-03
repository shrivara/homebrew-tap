class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.109.tar.gz"
  sha256 "88afd6be8c5f03ace94e35160bb1c1d7decea56146548b9b7bd7c1e51e73e9bf"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.109"
    rebuild 1
    sha256 arm64_tahoe:   "92356a0a98abc0efce3455b5dd4c977c720f63b262c445a9864a6a9903dd2840"
    sha256 arm64_sequoia: "8394daccdbd897ee5edf2523b18cf53a8414af2818a9e47e1c9b5510caa255ff"
    sha256 arm64_sonoma:  "6f3d90f277089e333220f38c6f2a3c38de6aa733be55ba57a2015d04a506aec1"
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
