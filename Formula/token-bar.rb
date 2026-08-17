class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.23.tar.gz"
  sha256 "086f43fc2118f8a607dc43402ac95ebb8aa62a8816f174c47fe665d4ca597bc1"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.23"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ec7a6d5521f8cdeeec699e17b9fd060f875e1aa6c963f8dc3d249d47f78b738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e4d3a6e4037ca63322df606858628cd39cd01b80171fec5777fb2cd50e9f6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6deb3f9bba2dcab646fdf775ab110c886ec11b3f494651c971c31b3b0db275b7"
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
