class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.86.tar.gz"
  sha256 "9377d920598e26eef6d208c3ecc84b4cf54753b45cc0f74bcced625853df9983"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.86"
    rebuild 1
    sha256 arm64_tahoe:   "88eebdc01f8dc27ae0ee44445f374886d23cc1b4020ee47edbf188c8f730c726"
    sha256 arm64_sequoia: "55e12e1b0a13485238b48e7afce56c3b8b2de4a43fb21779c4b6df9c532aea41"
    sha256 arm64_sonoma:  "d6ee30e5f761c8f5b2821dcab7b0d6bf2461ed40baa481420489b481921a0917"
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
