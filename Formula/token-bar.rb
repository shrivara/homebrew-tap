class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.16.tar.gz"
  sha256 "f3060dc95dfac83b013ac5cea8527e3339ce873909e3b5917d63189316f10d20"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.16"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a3d60415647d2264bc58affd9c82d0fa33d3736a84366c726d5e0eda02e3e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aa48080732a9ad5f4d7f383124ffc447a4c52453c7074215b749b604fcbfe8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82457c61da3c8f47a7c1b2eea742fb74cc0065586a9105ec86e80b80a395dec4"
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
