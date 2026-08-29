class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.36.tar.gz"
  sha256 "d244a911f7de067be986c6405a78609280006ebf9719f727285bb4178000df76"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.36"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4437f15f6e5f43fedf167f73891d9d8dd52816d14c7d485bb0bf734009873feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88cbab8a47bd878d7e7c09b01802199145c1bf3dc0921a9e6fcade92e5bec0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29135d3b6d2fc26d2141fc81034da86357c3aa195ca17e7c3201046a32809b63"
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
