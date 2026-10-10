class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.84.tar.gz"
  sha256 "8a8af32bc56da6c4913dd0e53b44a81b9d5d1a7bd11b98d31d5eb2b1fbdeac4e"
  license "MIT"

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
