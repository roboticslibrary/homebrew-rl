class Simage < Formula
  desc "Image format loaders and front-ends to common import libraries"
  homepage "https://github.com/coin3d/simage"
  version "1.8.0-1"

  stable do
    url "https://github.com/coin3d/simage.git", revision: "53ab9d3124e91a46b743e2eef67b1f5abb6e2dc5"
  end

  bottle do
    root_url "https://www.roboticslibrary.org/bottles-rl"
    sha256 cellar: :any, big_sur:  "f96a8584cae52460e1491327adf1b5a0371184e738ebd0447331ba8ba42afb77"
    sha256 cellar: :any, catalina: "7f5f3f7255a4b85f230b739313cd0c7b2a1d60f770bfd01ce3eafc1625da99e7"
    sha256 cellar: :any, mojave:   "42553fdf018bf4cae2aa069da6e8d922cbf6ef1ff606d7f0769514feb16bb969"
  end

  head do
    url "https://github.com/coin3d/simage.git"
  end

  depends_on "cmake" => :build
  depends_on "giflib" => :optional
  depends_on "jpeg" => :optional
  depends_on "libpng" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libtiff" => :optional
  depends_on "libvorbis" => :optional

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DSIMAGE_BUILD_EXAMPLES=OFF", "-DSIMAGE_BUILD_TESTS=OFF"
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
