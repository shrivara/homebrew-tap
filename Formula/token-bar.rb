class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.47.tar.gz"
  sha256 "9d759e26d9646338c86b17c3de2cfb70a6576f0a9933ac6221faf326215d4487"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.47"
    rebuild 1
    sha256 arm64_tahoe:   "7f2dd04a93f828eb147302cf0645955e4cc700396d5cb1387b7aa8a3eacf4e38"
    sha256 arm64_sequoia: "1c4d68b8fd1dcf9e472c2f5f6c3480d842d7854dbe5d809442941bec45195510"
    sha256 arm64_sonoma:  "ff6ff36b25bdb4f3f21881d0adddb800d65e913ada93ee3c56970d53f8b24896"
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
