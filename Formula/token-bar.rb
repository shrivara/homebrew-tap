class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.27.tar.gz"
  sha256 "bc7b987aa020f897e703511a2f1a7d5001b8f6fd91885a38156008d659edcd55"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.27"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b27d5d20273d9fa6a224cc0ce526ef912592fceba689c8b38bbcd97de76d6e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e67f5206a64bbfa4ad9c5838e00709a5fe3d0eeaeda09286e4e9a736e35dec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f283dbf980a04a9c25b26c6804bf934dcf01b272c092344a4a869d2b4491284"
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
