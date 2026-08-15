class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.19.tar.gz"
  sha256 "878e4e906ba50155ca1cdbf39b836229fea06280e1a5a26249584d03fddf976b"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.19"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca02aa91d83f4118ad8851bd18eee1922b26fe19b9856a76014ee479a08aa374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0fd93d1701b2914699b9ed70056be025b36542091c4531aee47befaf9fb0214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf93367f9c83daa674877099cf40f1287886464634f55808bd6d81e02844825"
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
