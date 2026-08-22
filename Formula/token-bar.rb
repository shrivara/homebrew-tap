class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.28.tar.gz"
  sha256 "afa3eeb1499a22ea896743859bbc99a841d61638dd126e46985cd47e301effc8"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.28"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a1c7d585f4a7368a7ce9141666ffa19195b329cadd5c9295a1dd333b3139dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822274bc1a4be93997f31286939018575351db04eb1dd2ffb1e1f16c1804a08c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d455281cd80ab4b212425d23622b38cd08dcf7447c733a3928a3e497eb012d6b"
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
