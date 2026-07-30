class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "5ed08d0abad23f23cd204665d0d833e179614b7fc7348bb326291f4c675207e7"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.7.8"
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "464efc1e677ffd3c00979e4a43f51023135d362ecd00111805e29c1602c2947e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44449325af293837981b6cdbbda78714d88f4b21a42fb710fd9e0d92ae94e390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e319ea710e8edc6f84e7a9082fa1858d50c0004b7fbbfd24626cfa5728d266c0"
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
