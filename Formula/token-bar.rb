class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.67.tar.gz"
  sha256 "2940580c7726795b86821aea51fa6db3ee5ae819fc3730cf39adc9551e955f75"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.67"
    rebuild 1
    sha256 arm64_tahoe:   "8b64aaf66a66552a8a7b2d684bfedb5f58a845d1069e36eb6e3a4625952c5fdb"
    sha256 arm64_sequoia: "40553924282dca4e3cfc4d857d6ac4e5e54ffc0cd63f7cc4df8d1edf8da75185"
    sha256 arm64_sonoma:  "db481fbf1276e55d38fb396e8cdde1a516e4cb1af7da71bef84e82cf2a9b6710"
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
