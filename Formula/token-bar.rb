class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.98.tar.gz"
  sha256 "904957df577e11d16628188b33871dfd0c9283cbac8b57cb75f6aa53a131f92e"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.98"
    rebuild 1
    sha256 arm64_tahoe:   "7649ee92a75848a4a43a151e1480d9d52c1708d796a4e7cb933546e7b3c8c2de"
    sha256 arm64_sequoia: "f0bbf6324040746a2650df91e01b524cabfe226c5cce28b54b415728f8a40a11"
    sha256 arm64_sonoma:  "38288916ed8746d5b72ef35cbbf37db236e395f051f2c2047ee8d467b55ae0fc"
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
