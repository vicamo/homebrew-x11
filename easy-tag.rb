class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://projects.gnome.org/easytag"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.1.tar.xz"
  sha256 "b9ef5f47572f44985922230f94b5ac908d4c7a12430dac662fdf1b48c7e577d5"

  bottle do
    sha256 "f7cc4f6dd42357f1162031e15dda2411625ef830f586c576dc436ca3d782216e" => :el_capitan
    sha256 "8d7b0814f8b08b91f6076fbe6aad15ac21df98016a05f7793f76dbd0b3326a51" => :yosemite
    sha256 "2b5f71039ef2d55c0c9c58e26423fe7adbc20832c99b7a72c8c2c7df238e6ccb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "id3lib"
  depends_on "libid3tag"
  depends_on "taglib"

  depends_on "libvorbis" => :recommended
  depends_on "flac" => :recommended
  depends_on "libogg" if build.with? "flac"

  depends_on "speex" => :optional
  depends_on "wavpack" => :optional

  # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
  # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
  # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
  patch :DATA

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/easytag", "--version"
  end
end
__END__
diff --git a/Makefile.in b/Makefile.in
index 672f271..94e84a8 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -1124,7 +1124,7 @@ dist_appiconscalable_DATA = \
 dist_appiconsymbolic_DATA = \
	data/icons/symbolic/easytag-symbolic.svg

-UPDATE_ICON_CACHE = gtk-update-icon-cache --ignore-theme-index --force
+UPDATE_ICON_CACHE = gtk3-update-icon-cache --ignore-theme-index --force
 dist_noinst_DATA = \
	$(appdata_in_files) \
	$(desktop_in_files) \
