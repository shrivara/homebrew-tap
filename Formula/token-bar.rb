class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.35.tar.gz"
  sha256 "d55a4b7fba644a81e8bb0ef34d5d2c22b263e9f4d0f9953a58be241610e31e9c"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.35"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93fcf84c44e5ebaf66471d44556e5add94155ceab1f5dd3eb4cb4b8df3fdbee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d139f9ac00c7188c8d5d590e9a377d72505e16a3af47c5d474bc89036a822318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8425f673aa2c0b11f45ce90e81ca09cc613ef92bacf9aac35b509a21826ad3c"
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
