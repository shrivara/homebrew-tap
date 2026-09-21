class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.65.tar.gz"
  sha256 "20cafb6f58518cab27b8644979a1eed4b8a53b5504894a900deb63ba845fe203"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.65"
    rebuild 1
    sha256 arm64_tahoe:   "53d609243aa90b6941d139c0b669d9f49d938974839da8fc3b3e1ad51f4c16cc"
    sha256 arm64_sequoia: "2f69fcbc80676a31cb9cc2da0e8bf30492084afc987a844d098591ff6c5a25c8"
    sha256 arm64_sonoma:  "e4ff7861b4aebd061fc14729333621ba8e4d55212be78529916caf8a182f5df6"
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
