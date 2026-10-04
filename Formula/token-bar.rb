class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.78.tar.gz"
  sha256 "47db47a67a3205eeeeda75f94a789dde8f718ef20349832c391098f9e4356735"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.78"
    rebuild 1
    sha256 arm64_tahoe:   "852dc724aecb781bf781b14b8f4b8bfb8fdf31c8296f84ed985d3e4d3aeeab33"
    sha256 arm64_sequoia: "3c8438a548e1c75f80dbda1b8fce7fbaf7297fb52149a0bbfb1a18ecc5c653ea"
    sha256 arm64_sonoma:  "5c056fe096c1a8125262f0a6143b30ad14106399a11891a567cd5c11decc0b57"
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
