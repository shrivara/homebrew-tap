class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.17.tar.gz"
  sha256 "cbb28125ee1be7b6f55102b71d7d52f77da0d260034f58f947992c7c5352ac97"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.17"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20330ab46c83f9f19c69bee8f2382c0c824bacc478d55a5d0219ed8641a35d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f570b8cdb3b2c55bd7fd461722b804b55f46e72157b6db41509352b6d5f8bc9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d709443ea902125fb2ff5a5bfe3c95ac55b27dab922722c4fdd30e3b5658def8"
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
