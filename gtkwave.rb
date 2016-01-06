class Gtkwave < Formula
  desc "A fully featured GTK+ based wave viewer"
  homepage "http://gtkwave.sourceforge.net/"
  url "http://gtkwave.sourceforge.net/gtkwave-3.3.68.tar.gz"
  sha256 "9846ced0601c32c87bfda236ccadc2c6435a76c3a799b0d17ed54a5d7391343e"

  bottle do
    cellar :any
    sha256 "290a1022afc3578c32d924447698c5238c4e30538336eeacc2b096236f9efde7" => :yosemite
    sha256 "5cf8d5a2405987be2cd7c6e01284aba5befe7616decaf007732636bb8e30291e" => :mavericks
    sha256 "5971a74f75e0c2f9ac99863391d11744b56253a16ca80fd52ff821eeb7af4c4f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on "xz" # For LZMA support

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"
           ]

    unless MacOS::CLT.installed?
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
      args << "--with-tk=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gtkwave", "--version"
  end
end
