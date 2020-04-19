  homepage "https://github.com/coin3d/simage"
  version "1.8.0-1"
    url "https://github.com/coin3d/simage.git", :revision => "53ab9d3124e91a46b743e2eef67b1f5abb6e2dc5"
    sha256 "7f5f3f7255a4b85f230b739313cd0c7b2a1d60f770bfd01ce3eafc1625da99e7" => :catalina
    sha256 "42553fdf018bf4cae2aa069da6e8d922cbf6ef1ff606d7f0769514feb16bb969" => :mojave
    url "https://github.com/coin3d/simage.git"
      system "cmake", "..", *std_cmake_args, "-DSIMAGE_BUILD_EXAMPLES=OFF", "-DSIMAGE_BUILD_TESTS=OFF"
      add_executable(testSimage testSimage.c)
    (testpath/"testSimage.c").write <<~EOS
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
      system "./testSimage", test_fixtures("test.gif"), "1", "1", "4"
      system "./testSimage", test_fixtures("test.jpg"), "1", "1", "4"
      system "./testSimage", test_fixtures("test.png"), "8", "8", "1"
      system "./testSimage", test_fixtures("test.tiff"), "1", "1", "4"