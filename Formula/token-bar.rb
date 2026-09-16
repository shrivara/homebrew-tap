class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.60.tar.gz"
  sha256 "d8f6ee15bfb3d8495580f271f8ec83c00968a30db4418c3ce7b36051c293d4b3"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.60"
    rebuild 1
    sha256 arm64_tahoe:   "92333df82cd3d2cdbf9021603bfbcb15e1f6c270fd07d0e2d4e288d28543f8b3"
    sha256 arm64_sequoia: "765d2b19475b6883825015b5f1c5f7007634d48a2754b569c26025107bdb5e59"
    sha256 arm64_sonoma:  "0d1c0f6617794fbc22d78cff9fd3b14fd9147c21d21b55e778364b173f4867b2"
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
