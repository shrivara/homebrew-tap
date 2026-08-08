class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "ad9bb76d066dec8b4f3ad8e69a519ae3beede4ca5da377cf71a26fe20ad89a65"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.8"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400eb096d4f60e136ad13149c28e8c31bb349a30fd9f718e0e55960dd48277b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2299ab001c99e7bf4dd14b6554ee42cdedcb884cb89419e7577228694a9114b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d236ceda04b7d235adef047d63dab717e6140058cd5a4c522491724ec81500cd"
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
