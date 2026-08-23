class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.29.tar.gz"
  sha256 "46af9eabc5b91b14b5a3b3e32789b49ba7dd1a8038855693a6d1f387b316d639"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.29"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9043556fdf0e10684ba1e8b2bae421e6a33b80a1d6b39d7c99ee4c8d09f62283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb910423948f3f5b9c72573c0c3afb4b2d1c09493aad5df6a76624d5f3b3671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7616ef82ae91094ffdf5d14f4bea7faef1594a132d2a08cd7ad0fb72198f8183"
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
