class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.75.tar.gz"
  sha256 "0aff757751ec7856b7be2f054da5336fce5d73cfd35ac5f9d8de16d5e5331062"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.75"
    rebuild 1
    sha256 arm64_tahoe:   "061875ab50cb69333fdd823da5f3b795a2d959014fc3d1b3cba4cb8824c24024"
    sha256 arm64_sequoia: "356e1632e75a6734ce5b03f770ddc03c195b5cc33c736a87dbbd8610e9b51f44"
    sha256 arm64_sonoma:  "37c04f5a18cada684dde8ffc0a58c51584ad0c3ce8719f45c80676dc263e01ee"
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
