class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.76.tar.gz"
  sha256 "bcff7bbd958bba89971072c2ac7b138a68e5e80b11f112defe0ce917025e7186"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.76"
    rebuild 1
    sha256 arm64_tahoe:   "b783ee9d1ab545fdb4f3a53529f8c600e2c9c692e476ddaaad69395e8f53fe86"
    sha256 arm64_sequoia: "7041ea2264c9d8c7d5c5367b57a0b9fc8715df0404d9214c7516753d60860f40"
    sha256 arm64_sonoma:  "1ef0a07b6d7e733bb7463314a5775b2ad54094ce29f4431ad034e5277113c1fc"
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
