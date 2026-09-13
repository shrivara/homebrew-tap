class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.57.tar.gz"
  sha256 "8df793d8e75eafdbf2704bd8dbdb5e7944f119fc3299e9927b996fad958ba902"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.57"
    rebuild 1
    sha256 arm64_tahoe:   "65c503a5df8ad2b4191721d0dc9dba47934a53c24f05a444cb0e3b08530e0fef"
    sha256 arm64_sequoia: "ffa87148b2270b0e98c1d79fd97c4d4de35ef17e3ab2071e498a149f128e22a2"
    sha256 arm64_sonoma:  "e12be97c839b924b96e7e4ab2cf8821733bba933f9255a89af08de7766a17d97"
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
