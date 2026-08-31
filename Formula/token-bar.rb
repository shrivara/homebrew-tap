class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.42.tar.gz"
  sha256 "27ed130719dcdc268fd33fe1b4fc4bb395cfe747176899c918583899e24e5bd5"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.42"
    rebuild 1
    sha256 arm64_tahoe:   "ab9d5c70cc73a5961cc0323b3b052b639055ef8601b3864b5b7d81f1a4ab6fb5"
    sha256 arm64_sequoia: "394bdb6022b11b818cbc1ba222a63633a1c641ba5f9b41511d11f794a314427e"
    sha256 arm64_sonoma:  "d533f6399e794be356f8bd5280b301f0b53c8bf3b26060ef551725d01f4400c4"
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
