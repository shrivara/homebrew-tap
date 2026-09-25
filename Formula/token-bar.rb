class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.69.tar.gz"
  sha256 "e9b7f96435a3fe75c39ea4ac610c7548056bb51d303769cd6c0d655f0d9d9b39"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.69"
    rebuild 1
    sha256 arm64_tahoe:   "b8f4c087f1bc276463e592b3eab11add0b5346302120ee3a8d85fdf8f09225e2"
    sha256 arm64_sequoia: "072ec3e34b82c174996c3d6199d95b9df772d0a6d1545d1449f27c1b6b26d69c"
    sha256 arm64_sonoma:  "d20eec3e62064006d5569a8529402469db284a0a44fc700e0d01f74ad171237b"
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
