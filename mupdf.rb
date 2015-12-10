class Mupdf < Formula
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/archive/mupdf-1.8-source.tar.gz"
  sha256 "a2a3c64d8b24920f87cf4ea9339a25abf7388496440f13b37482d1403c33c206"

  bottle do
    cellar :any
    sha256 "cd08e744981da8217edff2417534197b6fc1123057044672af4ad45454c18995" => :yosemite
    sha256 "8d4a45552059a14df044e32152d8907d3b0e95f0445a9d10bfe0d876e4d00ca4" => :mavericks
    sha256 "4692fc5f8ba4a47b7d9efee0b2e1251b0a3538eb0dcebbf5e2e0392a8da28a94" => :mountain_lion
  end

  depends_on :macos => :snow_leopard
  depends_on :x11
  depends_on "openssl"

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"
    bin.install_symlink "mutool" => "mudraw"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_match /Homebrew test/, shell_output("#{bin}/mudraw -F txt #{pdf}")
  end
end
