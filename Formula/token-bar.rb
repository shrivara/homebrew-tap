class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.46.tar.gz"
  sha256 "32649a833ecd2f724b12945c329aa6130b552f34aa06befb89882235e1ecdf84"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.46"
    rebuild 1
    sha256 arm64_tahoe:   "fdd2797ad56dd27ca0da1df98c19fdb64b761e07289cc8d7e1883a6962f4c9a1"
    sha256 arm64_sequoia: "e37da41b4cb38f7407824ee3ddc1cf1a8d11bb3c1686db759f168b2c74121c05"
    sha256 arm64_sonoma:  "203bbd8fc6fed33729cd8d34576d70d251616db9359ebdd1cf97725c41fe7a15"
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
