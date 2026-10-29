class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.103.tar.gz"
  sha256 "8ab19a1ca3e99e1c68b88a020017df0cd1ae5dbdd4990b6d8fdeb15e64a73fb2"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.103"
    rebuild 1
    sha256 arm64_tahoe:   "83656b010a0d9594df026f52a01a6a73fd5a262d13784c620ca592bd826e851b"
    sha256 arm64_sequoia: "5706e65f4e9731463644ed6aa6e36fb39006ef0a59c7b01423a3bcda889e31ea"
    sha256 arm64_sonoma:  "2ee8784695db237134127c146dac1abfdbec5fe1ae786ffa67badd08a7a4babf"
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
