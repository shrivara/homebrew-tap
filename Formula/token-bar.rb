class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.53.tar.gz"
  sha256 "64786c2984d13416e617ac1ad126d57b08616d4f4f46c1084b5babbb06393bf5"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.53"
    rebuild 1
    sha256 arm64_tahoe:   "41b2f3d408fd242c7a46d5c5d43c2ec896ab493979d31e408c06639ce87be365"
    sha256 arm64_sequoia: "14a7b837e853f8e6ea4d15ddcb829bf03e55b138c9184726bf2cdcb45a945617"
    sha256 arm64_sonoma:  "362fab75110dc3dd2d5a12b4af651262777fc49d4926a6d33a74fb05331b7b00"
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
