class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.34.tar.gz"
  sha256 "df96189c993fe33a7cbfa4c224a6928fca48310d3801873ffdb7115b0067c623"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.34"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "506c99e6cfd3ca390f2b10def3a466c906f9cd70475fbcea313fff493e457b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592e6d746ae6f0ef21a179e7567cd109b82850aaad49ac4293062335f2de294d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd15df80ef23e1e24e274fbd9262f06d9190d8dcb76e35e803e00ab021d0fe03"
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
