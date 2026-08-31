class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.43.tar.gz"
  sha256 "dfe479f754c556f59063d51d7914fef5fbb79703add8f3ed7d6e616df3225bbe"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.43"
    rebuild 1
    sha256 arm64_tahoe:   "65e0cb2d718c410d53b56a9051d763b7b203b4646dc196c14c5d05ed872165dd"
    sha256 arm64_sequoia: "7f744066a1a01ed5b1a59f7ae8fde439d6f4679699d8b32738af96118ca73cc3"
    sha256 arm64_sonoma:  "832d989c6041540d30268a1b3267b276987398e5755fb6ee396d9a52c89ceb9f"
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
