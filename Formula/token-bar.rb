class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.10.tar.gz"
  sha256 "c11eb2ba655343d3048856f06869b2bf9726a20c5e7072b2185d57f93b7b38c8"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.10"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8385bb3fe83d9dd94066a27ace0225a7b42150bc1c482a4c24796b0b0f46a5a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c226d714fd69c5b21a474812a43dbfddec845fe0c302b1169ea47f9462a83423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68364f5f1b6569b7e947878ae7638bab175f79472017ed85fe85f94bad37a11f"
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
