class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.38.tar.gz"
  sha256 "33e7a7c06b0108cddb74ccaa5265d41b11abbe053184f51f86bd85af8322f2dd"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.38"
    rebuild 1
    sha256 arm64_tahoe:   "ba3a7882becee1bdfb7c4530426ae32f051a26faa957bef7ba0a9b0bcb7098cf"
    sha256 arm64_sequoia: "831411d3bda92b9b5055740590047131326c7aba241db9950a1462d548ba7754"
    sha256 arm64_sonoma:  "afe2d4aa1cfc8303834065baa96e88c5c4dd70e2c0c788d16967fcd152502631"
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
