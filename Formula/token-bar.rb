class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.26.tar.gz"
  sha256 "280176e9318c7a74959917aa40d97559096ab6fd555bd5be4880fc59bc5dec7a"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.26"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e7ccddff123d3c0e53716b9e63a5ecf882b9a54c88007bb4f0c02ecdfe066f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c46ded96c3e0e89771fefa108987137ef526d95efd47575feb71c12e6e5024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24cefa57de8c503051c18bd1dd93e64bc14f62feaddcac701a54cb4c7438f24"
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
