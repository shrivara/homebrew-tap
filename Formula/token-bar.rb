class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.20.tar.gz"
  sha256 "cf52edbf777dd14dcff95e8c19bafef44a42a7a20d7d5afab7cb5c030bc81196"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.20"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa7c6aaeae96f6ccf3059521e745fa50523f66f90cb6bbf4ecfcee0a9bd4013f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e68465e07ffbf3738a086b7cfd70f69a9b553ac3e91e6970b5daf4ae6dac1a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a5f430ea3828eba1ea78071c149f87c27f6a1604193716478842e34b5853fc"
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
