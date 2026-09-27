class TokenBar < Formula
  desc "Menu bar readout of today's AI usage (Claude Code, Codex, OpenCode, pi)"
  homepage "https://github.com/shrivara/token-bar"
  url "https://github.com/shrivara/token-bar/archive/refs/tags/v0.8.71.tar.gz"
  sha256 "5d06a36e8dc2c1e7b0d092eb878abd9f97014613919ede02d0bb5716f3954cce"
  license "MIT"

  bottle do
    root_url "https://github.com/shrivara/homebrew-tap/releases/download/bottles-token-bar-0.8.71"
    rebuild 1
    sha256 arm64_tahoe:   "902da35d5b5a34bf389fe8771393ccad8fbefc10a85f9d593a43078bb3513319"
    sha256 arm64_sequoia: "f914dbf7efa1a05e6fc88d4e96002b3670b352f9ec849cc15d8766e14f4648d5"
    sha256 arm64_sonoma:  "11388e88401204d5c8a873dd31627115b59033617cb0b1eded0b568eddfd9aac"
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
