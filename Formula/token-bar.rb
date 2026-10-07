class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.81.tar.gz"
  sha256 "cd6fc5bca4956278b5256680a4af3b0e5203d8c955428bd9f6b5ec8ad85b4917"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.81"
    rebuild 1
    sha256 arm64_tahoe:   "c72e77e024d22cac134f9414e268105a753f938cb7f86352e56886a2e531e4ba"
    sha256 arm64_sequoia: "5004e18e5f9168bd621c89740d5f848444dfc307eac5a241c0b3d5a9f616d78d"
    sha256 arm64_sonoma:  "f78018b39a5437cd6f56e1b5dc78fe0c8fffcce6884ad5e390f145f49a06b4cd"
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
