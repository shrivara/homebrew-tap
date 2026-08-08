class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.12.tar.gz"
  sha256 "f9f9c52badbfdd97deab7a447c4fda853cd35ba2c8023287fdf519f16c101764"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.12"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48bf45dcda23b94186726659a69f92dade943cd98545adae190b4de6e2e76a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc82f4076679f348081758ec37fc90733cd46e8ea09b85c4041ae3d42cf04dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69066eb86cc52b9f5e3f8e03e45bc3bc4d5252695e6c9df3dfcb1d5e7458ce51"
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
