class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.111.tar.gz"
  sha256 "aa4985391a26b97b21d4b87e15135380f53e4cab3015a710e2dcefd0bc05f6cc"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.111"
    rebuild 1
    sha256 arm64_tahoe:   "347b4b46801bae172a580dc3af240fa6ea13a9926eb568f2cfbd171b6cee61d6"
    sha256 arm64_sequoia: "c15fd4063ff905a66ea779d4c64cee590420bff90f79cbd419c9f485c9af92d0"
    sha256 arm64_sonoma:  "bf694143ab11f3230b0cab914aa81282f723c9969c5edec66428b342be6bbd0a"
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
