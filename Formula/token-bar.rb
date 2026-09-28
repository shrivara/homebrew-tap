class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.72.tar.gz"
  sha256 "48766ddd5e45841674d79218ac841ee55d4ba3159fc8132db5f07904aa2de9e6"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.72"
    rebuild 1
    sha256 arm64_tahoe:   "f725261bb9881101169d020f0fb09a44a971b3a1595b5350f839e44fe1c84667"
    sha256 arm64_sequoia: "abe7d7f70eedb367d2480a2d4d9bb3e3d0b0c4dcd0a2ca7471a5fe92f2bf08e4"
    sha256 arm64_sonoma:  "c309891aae67ac0e69bc8f3dcff5fed48fdd54ce6121e248f06e87643faec6eb"
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
