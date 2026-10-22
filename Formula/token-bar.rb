class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.96.tar.gz"
  sha256 "ac2b160c7f649747a96370a6f4ad69410ef3b05b189f3dbd1f2918de981822d4"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.96"
    rebuild 1
    sha256 arm64_tahoe:   "413fd7ef32f12d10d894d485cfb0354eda5251634694a0211379a271cb7802d0"
    sha256 arm64_sequoia: "9ebdd57027e1efc1f6b05863db3cfed7e3edf8adab848ec8e51db12eadbcadbb"
    sha256 arm64_sonoma:  "d6c03c4c266b803b0fd67b98fdebc50b159e2b09638d256b8a783be942a5e34d"
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
