class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.93.tar.gz"
  sha256 "bacffdc2810630b743164cf22f070dc443ce3a5f57fe25fad6b9f1a2d0008c0a"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.93"
    rebuild 1
    sha256 arm64_tahoe:   "eaf72abb858822d9191f43b08abfc84861d2f15443edc8c8cccd4e21960313c1"
    sha256 arm64_sequoia: "e032e2ec525473cafcc8a2abba13b896f3b8591de4d991a4641577915e600786"
    sha256 arm64_sonoma:  "32fa4f16f5a46d7eef147c4bf755e45a0bf2a7566b949b112c27f74a655a34d9"
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
