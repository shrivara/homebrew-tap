class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.24.tar.gz"
  sha256 "4681ee0abf05bb155c98b900cbc3adecfe37c7f9fae818cd9d360595518c6c76"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.24"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5432264e167d91762e4a52dde9530fffe1e742ef8a541f4f2df23f4ecfe42be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b177baf840ddaa421db327d52774d318de78441619a02887e5a04c19f82af7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72c165d8ddb3b3e5bd0aef4eb285db4faab27b6bad660f6c235cb678d9b14f6"
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
