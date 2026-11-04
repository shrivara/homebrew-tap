class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.110.tar.gz"
  sha256 "a86a4150e0f50489840b69061ed038f7bd38d30ea5ff73b3412435772f88ef22"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.110"
    rebuild 1
    sha256 arm64_tahoe:   "4c457596945dce3e82d5ad2ed7b8071e49b55bbfedbe3ba28486029d4d66c68f"
    sha256 arm64_sequoia: "86b6126a17f19ed80539fa8172f8a76a00d74203f8f94ad1125b40133980c080"
    sha256 arm64_sonoma:  "e12f5909fd5e006f579a22e1761e1c87b70bcc66e8ad591cfe2dbfc9545a04bf"
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
