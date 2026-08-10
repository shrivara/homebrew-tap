class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.14.tar.gz"
  sha256 "c0ecbb23193edd85fdb8cb81a823bda60441b47e0e2cc193b2798ca26c812961"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.14"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99a7232e5f5cfc8577936dfd90d69f366e25ba373ed6f9e5f696a4504f81e0f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f2eec7ffffb583c9dee6d2698691cab227718524b768f5190ab19eb133105b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dc7a2ba24a18886c3b32b579224c349b3ee8a4bc9fbe7d573e6d73adfe4b60f"
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
