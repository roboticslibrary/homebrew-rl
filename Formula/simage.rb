class Simage < Formula
  desc "Image format loaders and front-ends to common import libraries"
  homepage "https://bitbucket.org/Coin3D/simage"
  version "1.7.1a-1"

  stable do
    url "https://bitbucket.org/Coin3D/simage/get/afd8852f40c8.tar.gz"
    sha256 "bd6a2bcdfa036585d830ab5ea29c42991122dd89ea8d300b580168ffecb14f1b"
    patch :DATA
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/cf223b81fd77.tar.gz"
      sha256 "dab707c42138b42c0e1cc9bbae6a087004ab4717ec76a69b5b8dc20ac5b412ba"
    end
  end

  head do
    url "https://bitbucket.org/Coin3D/simage/get/default.tar.gz"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "giflib" => :optional
  depends_on "jasper" => :optional
  depends_on "jpeg" => :optional
  depends_on "libpng" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libtiff" => :optional
  depends_on "libvorbis" => :optional
  depends_on "qt" => :optional

  def install
    resource("cpack.d").stage do
      cp_r Dir.pwd, buildpath/"cpack.d"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end

__END__
diff --git a/packaging/macosx/Welcome.rtf b/packaging/macosx/Welcome.rtf
new file mode 100644
index 0000000..08778d7
--- /dev/null
+++ b/packaging/macosx/Welcome.rtf
@@ -0,0 +1 @@
+{\rtf1}
\ No newline at end of file
