class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.59.tar.gz"
  sha256 "5b7401c26054c5bd196015d76e23f2b6b1bac1d253d0bc7aa6d69f1e3ee25aa5"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.59"
    rebuild 1
    sha256 arm64_tahoe:   "a52610671aab3470d5652b852d151d92d1c46d7b41825bc2ffe9b6396235adda"
    sha256 arm64_sequoia: "ad7b5edc64e4cc9a9ef47d535ce24e88931b7b86ab3d6bc7488876fe4528999b"
    sha256 arm64_sonoma:  "fd2b3ce5a9ef0e15b8a5d650b9b56538bae63d04835de939e274629eaa109e04"
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
