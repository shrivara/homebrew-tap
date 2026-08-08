class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "9983581c953afc25a691c77f7cf03d15c2b6ef81b195995179c858d30c0afb39"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.9"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efe9cf73c86cc921e3d7f17922b9935278315373743fdbd58cdd8174cac11ed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9b2221c643a50e8b866a09fc1284ddb9e060960cc2f30608e0f21742a25907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc2801a4c2ab8b9be1ce233e897af8e044646412f23c7db10ecd50477f47b23"
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
