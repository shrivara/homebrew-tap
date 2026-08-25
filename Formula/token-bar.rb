class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.32.tar.gz"
  sha256 "2b61d61ec30ef5ba130e06a566225145a031c85bc358e690072dba59271bc51f"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.32"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371857e62dc198f7866fd407e2aeae86bec7e74fd619f7f2d789ff4f2556e699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca7a949329bc2986343572bd80ba5aa8dfaba2f76f4063ea6a62045807720c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f38536cdcb23872c93e7ae61421d7aa7750a2b64fb38a4a9d0b62e4261912c"
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
