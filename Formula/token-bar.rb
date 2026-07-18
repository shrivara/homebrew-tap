class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "59a3916e4ccfe18a951e5a340961c35e8f1219a6de3922695c63454cdb7e01cb"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.4"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b798c021451e670e30341b07039af7a49ae6b89be41a53b33d8082e665e10948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a0e4958e54b69120c94f4c5cec968e1acd1cd589bed72973c682eb68495b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879cbefaa426eb787355c76833721c05fd1865bd2b40ea4fb301b359ea965277"
  end




  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/token-bar"
    # SwiftPM emits resource bundles (pricing catalog, provider glyphs) that
    # Bundle.module loads at runtime; they must sit next to the executable.
    bin.install Dir[".build/release/*.bundle"]
  end

  service do
    run [opt_bin/"token-bar"]
    keep_alive true
    process_type :interactive
  end

  def caveats
    <<~EOS
      token-bar is a menu bar app. Start it now and at every login with:
        brew services start token-bar
    EOS
  end

  test do
    assert_match "TOTAL", shell_output("#{bin}/token-bar --print")
  end
end
