class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.58.tar.gz"
  sha256 "306be36c698daea29de3afc0845e22d3c43ed5ef93c5fb0a905ee35763ae8129"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.58"
    rebuild 1
    sha256 arm64_tahoe:   "84f0c2d2bb7ba7735b76e038a60dcb23029218f8a37ea635e395aeace6f66ab5"
    sha256 arm64_sequoia: "6ce52bf59cc87e26ba731c10e7d49c3db4655930bc9659e1a860a5588bac6614"
    sha256 arm64_sonoma:  "25511191529065bcb8400607420621fd16a9145a1594896d99dcd32852b5eaa4"
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
