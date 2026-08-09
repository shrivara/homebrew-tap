class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.13.tar.gz"
  sha256 "bd7dc310bbf0f4694b6ce580388c8adfea599125cac7d33b324a14ec15e5e4e9"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.13"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9caeb4279748e2e70c9414ec7d67c5f5a157b177562f7283eae154c96982e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e29c303047b19572886d57ead272565cde216d598c28ae69841616a8ab3653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39fe6c336f0aec7a27f1793bcfbce4b70f361f90de12e7254485b2f4055b5af"
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
