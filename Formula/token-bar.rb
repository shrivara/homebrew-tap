class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.15.tar.gz"
  sha256 "6527fb8b43ec4b2b4cfc66f89e26fc511e03a11f93ec602db55ad6c6db64cc91"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.15"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6871f99a3bb5bbd51d7c9edafec4773d270c127758a42884647dee0f4687213e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "001515fa8d8becfdd0e68a74b42963f336c46271fc01d5f46e923ea82dad7a5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3d872f16c447a4aec145d26617b16a6da7c4f0769360309720412681d4cbb36"
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
