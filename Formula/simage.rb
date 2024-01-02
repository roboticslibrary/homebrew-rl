class Simage < Formula
  desc "Image format loaders and front-ends to common import libraries"
  homepage "https://github.com/coin3d/simage"
  url "https://github.com/coin3d/simage/releases/download/v1.8.3/simage-1.8.3-src.tar.gz"
  sha256 "ffc0d5a00b74d1e15655ad195bd535f0c0828c9d0f464c1ea4167799c79f6fe7"
  head "https://github.com/coin3d/simage.git", branch: "master"

  bottle do
    root_url "https://www.roboticslibrary.org/bottles-rl"
    sha256 cellar: :any, monterey: "90cdcaf140cc86fe9f2e37a895beeb92aaebf3afe28f636553237964096498cd"
    sha256 cellar: :any, big_sur:  "09e6c8243170b144fd67514d769e6492eab66b5b80bab6d8a4d79b9fffc27168"
    sha256 cellar: :any, catalina: "665f7f5d27b50d23c8bc6ca6e4df99a3c3765f4b6db1edd5de5b77a5cc394abe"
  end

  depends_on "cmake" => :build
  depends_on "jasper" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "qt" => :optional

  on_linux do
    depends_on "giflib"
    depends_on "jpeg"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "zlib"
  end

  def install
    args = std_cmake_args + %w[
      -DSIMAGE_BUILD_DOCUMENTATION=OFF
      -DSIMAGE_BUILD_EXAMPLES=OFF
      -DSIMAGE_BUILD_TESTS=OFF
    ]
    args << "-DSIMAGE_LIBJASPER_SUPPORT=ON" if build.with? "jasper"
    args << "-DSIMAGE_LIBSNDFILE_SUPPORT=OFF" if build.without? "libsndfile"
    args << "-DSIMAGE_OGGVORBIS_SUPPORT=OFF" if build.without? "libvorbis"
    args << "-DSIMAGE_USE_QIMAGE=ON" if build.with? "qt"
    args << "-DSIMAGE_USE_QT6=ON" if build.with? "qt"
    inreplace "simage.cfg.cmake.in", "@PKG_CONFIG_COMPILER@", ""
    inreplace "simage.pc.cmake.in", "@PKG_CONFIG_COMPILER@", ""
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(testSimage)
      find_package(simage)
      add_executable(testSimage testSimage.c)
      target_link_libraries(testSimage simage::simage)
    EOS
    (testpath/"testSimage.c").write <<~EOS
      #include <simage.h>
      #include <stdio.h>
      #include <stdlib.h>
      int main(int argc, char** argv) {
        if (argc < 2) {
          printf("Usage: testSimage FILENAME WIDTH HEIGHT NUMCOMPONENTS\\n");
          return 1;
        }
        if (!simage_check_supported(argv[1])) {
          printf("File format not supported\\n");
          return 1;
        }
        int width;
        int height;
        int numcomponents;
        unsigned char* imagedata = simage_read_image(argv[1], &width, &height, &numcomponents);
        if (NULL == imagedata) {
          printf("Could not load file: %s\\n", simage_get_last_error());
          return 1;
        }
        simage_free_image(imagedata);
        printf("width: %i\\nheight: %i\\nnumcomponents: %i\\n", width, height, numcomponents);
        if (width != atoi(argv[2])) {
          printf("width mismatch\\n");
          return 1;
        }
        if (height != atoi(argv[3])) {
          printf("height mismatch\\n");
          return 1;
        }
        if (numcomponents != atoi(argv[4])) {
          printf("numcomponents mismatch\\n");
          return 1;
        }
        return 0;
      }
    EOS
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "./testSimage", test_fixtures("test.gif"), "1", "1", "4"
      system "./testSimage", test_fixtures("test.jpg"), "1", "1", "4"
      system "./testSimage", test_fixtures("test.png"), "8", "8", "1"
      system "./testSimage", test_fixtures("test.tiff"), "1", "1", "4"
    end
  end
end
