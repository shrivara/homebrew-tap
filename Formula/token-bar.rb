class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.21.tar.gz"
  sha256 "5b41953382f02f369d837ce57f01aae12ea06de80dfa77156048ffc24bbe77b5"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.21"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c241fee5644ce8bab2ef5052e568587375a574e52e9b79ac0e9328941831f36d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8289536fa2b13b3a21fd8978cfa692cb7ce0a7a22044d4baa9ec2f5472b52f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd293189522eb5c357a840b05340a8adc99c2c021696e6a53e81f354b80ec3b3"
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
