class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.85.tar.gz"
  sha256 "107f8133ad5d7df2911fbb0aefba3951b612a79f889172b218e9189923a10644"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.85"
    rebuild 1
    sha256 arm64_tahoe:   "bf691bce5296e3d659ccc99c3d3a6ee269c172c3ba00176393e7d822cf9da1a3"
    sha256 arm64_sequoia: "e6aa2b62f3d9c87ac3fa3351b3ecbcf7505f2463034eb1bd1dcf4b9323d2250d"
    sha256 arm64_sonoma:  "ac41f66500ebd6558013f28f95725ca21d7e5d00d43ff5c11dcbdf226a5d671f"
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
