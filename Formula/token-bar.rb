class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.25.tar.gz"
  sha256 "871c1eddacac178350a4486335ee2dda73f657d49acf0ef3ba66fe4aff6d5c6c"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.25"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "471a10bce85e360f0d49d57267bf78d13eb32f5fcaafe7f3450843351f99f659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925efb936e68266a37e4b286b0580de3a42d756f773287d6da505cb6827b9e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ba7f2865b6dc3a78b437321b74688cf94805bf2f8a7c106dc658b6f2680ed9"
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
