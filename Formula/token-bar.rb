class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.63.tar.gz"
  sha256 "bcde67c1c58f9fa2fd77b235113f25524314b2ab2e5e691c43512d5afcfd2e02"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.63"
    rebuild 1
    sha256 arm64_tahoe:   "e234956e44fd1e454dd1586481801eb71633d52e5ea5b131db9766e430038573"
    sha256 arm64_sequoia: "3dfe13747f89e81e9fb2fdfcdd1c50b92ba2f22b14980e790d20762e16cb70f7"
    sha256 arm64_sonoma:  "fa4804c0769035c552d09ba94b7b3e8cdfa3092e64600d3b5856c85d6bc625a7"
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
