class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.39.tar.gz"
  sha256 "6265c7eac4bdc971ddc748c4aa80a0dfe6ee428100191281861ec85200695721"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.39"
    rebuild 1
    sha256 arm64_tahoe:   "ed0bdcc07bca204ff33e481a62aa8a4d55a7c391e2ed7c393dc5bdb24895e2fe"
    sha256 arm64_sequoia: "d8a92dbdce78f22feb0d4600a10b2df51df710bfc89ce9cc48e67665081d93c6"
    sha256 arm64_sonoma:  "defd41d3307345714ec2b0a09ce95e49ab2158b790e94082b6c459c520a25dc9"
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
