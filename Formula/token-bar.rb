class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.91.tar.gz"
  sha256 "e3c1e439ccbafd17c1ce7fb6ef89c9b9ec5c8e13a1f4ea797617b6dcbe468d14"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.91"
    rebuild 1
    sha256 arm64_tahoe:   "5da080778bd54844b8dd1fb07a4f3e49792739ba40af8a9bade6af4a65f831ea"
    sha256 arm64_sequoia: "a97316b759640a4dab465ffd4ae58ed548287907a08cca07dcdc4675dcc3348f"
    sha256 arm64_sonoma:  "bd51996b244f17679a1ff64c3d8e2b464981720a4d6f32eeeed785a0360ef2aa"
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
