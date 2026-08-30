class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.41.tar.gz"
  sha256 "50425301dd195cf4ac02992b3de7dc3be05c4862b3c9f0cd1187d98b7f78d1f9"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.41"
    rebuild 1
    sha256 arm64_tahoe:   "f694d53611f38c4039fcf7f0a573149db95830903f46df860346384f7c5d2ad3"
    sha256 arm64_sequoia: "b662bdfc4b31b141ee56e1cdad0fe1dc5e83e117630a6f5f332ab2f34101a259"
    sha256 arm64_sonoma:  "697bfc4bc5011636b286e0d75cd24de73f6a0655a72d974f062d2ab22d61de73"
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
