class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.30.tar.gz"
  sha256 "a1f5f8dcb5395f41046c35f9777b217f1f507122ca155903e7567fab6f2a4ac8"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.30"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e6df4bff40bd450ac14b47e92648751420ea3ae511bd22b2f8684434c9ac619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b81f6aa652239997c42a18944d6cd7ea1121a609de284e6225076dc2008dba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d4310209bdc1bd443138012c4f28e4cb537c2a3f7d1a6704a4eafbc3c59068"
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
