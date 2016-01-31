class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://projects.gnome.org/easytag"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.1.tar.xz"
  sha256 "b9ef5f47572f44985922230f94b5ac908d4c7a12430dac662fdf1b48c7e577d5"

  bottle do
    sha256 "1000f29472e58ce6e4b7c076b2ce4ff25cd67fcef7cda40fc7a46d15f74d8435" => :yosemite
    sha256 "70d49235dc4e64c2bd8548e9154066cc8f9bb9c09fcabf409e812956e396a9c7" => :mavericks
    sha256 "8310b39c9f259b256c69a0213297281b76bbe5b784916b78f52fcbb82f99b3c3" => :mountain_lion
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
