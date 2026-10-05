class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.79.tar.gz"
  sha256 "0a62415fe3289fe31bcfff9f9d4d5d44838894d2c256177e0c87eb38aabac58b"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.79"
    rebuild 1
    sha256 arm64_tahoe:   "f43a86caf8ae3c83d1f100cf35a4c353ae6e96205c9c07675410e3c11bb60c40"
    sha256 arm64_sequoia: "0c46071e3c9fa8027855146b1301134deca64d8413108ad98d2612d1a920fef5"
    sha256 arm64_sonoma:  "ba53839dcb703929ccc25e6d40ce1bfb0937218f52d9eb9e87e0ff46a6c3bbde"
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
