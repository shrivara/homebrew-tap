class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.87.tar.gz"
  sha256 "1ff36748ea6f697d521db6e3df6e72ce2a1d9f9620f304f1e595779bd39b6eb6"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.87"
    rebuild 1
    sha256 arm64_tahoe:   "3cbd81cb5dcb31ab3bb27d5005fa226ad2df8fbd97f74688909c347dd28e06ae"
    sha256 arm64_sequoia: "151240b132835994c42e60a2de8509cdeb51c397aeceb6fdaaa1d632f01023e3"
    sha256 arm64_sonoma:  "456225a08ee26362750a372be74fbd8870087843b87031e041135ddb17b10524"
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
