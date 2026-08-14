class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.18.tar.gz"
  sha256 "afbaee7fff73e316b3290f6e7e8a2f49c3f127a7ab3bdbf9be2d1f759f105f14"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.18"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4656b207065f8517359ce3e37d42894fbf58185460c300385f2128ead1cf415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f10f7aba9d8a3f4a77b44d8c9ff332477b08ee220ba0795649ba01811b6651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb9650c4211a9f657f079d34be4ac73c0a170b9be84ccd4bfd054a08641a9447"
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
