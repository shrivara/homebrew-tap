class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.31.tar.gz"
  sha256 "52998d3e001265b4b819e7cdf14916605610c395e297b61d60f46806c19a3242"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.31"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ddc3c61cae57831f6da029016f6edb69629911b4e9a633d9ad1562c15729a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721683ab213c66261863b30425ea1808521020ca16f7989ca5338007e545938c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77cf026c6bc9bc4ece1739457011dbf356fbb4a7e284248b199a25326a4daed"
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
