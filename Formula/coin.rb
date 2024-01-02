class Coin < Formula
  desc "High-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://github.com/coin3d/coin"
  url "https://github.com/coin3d/coin/releases/download/v4.0.2/coin-4.0.2-src.tar.gz"
  sha256 "bd6bce1efedfdbc8a914bc11a10dd319a16d19c3ccc6979faf5c85e5e94a416e"
  head "https://github.com/coin3d/coin.git", branch: "master"

  bottle do
    root_url "https://www.roboticslibrary.org/bottles-rl"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCOIN_BUILD_DOCUMENTATION=OFF", "-DCOIN_BUILD_TESTS=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(testCoin)
      find_package(Coin)
      add_executable(testCoin testCoin.cpp)
      target_link_libraries(testCoin Coin::Coin)
    EOS
    (testpath/"test.iv").write <<~EOS
      #Inventor V1.0 ascii
      DEF test Cube {
      }
    EOS
    (testpath/"testCoin.cpp").write <<~EOS
      #include <iostream>
      #include <Inventor/SoDB.h>
      #include <Inventor/SoInput.h>
      #include <Inventor/nodes/SoCube.h>
      #include <Inventor/nodes/SoSeparator.h>
      int main(int argc, char** argv) {
        if (argc < 2) {
          std::cout << "Usage: testCoin FILENAME" << std::endl;
          return 1;
        }
        SoDB::init();
        SoInput input;
        if (!input.openFile(argv[1])) {
          std::cout << "Failed to open file" << std::endl;
          return 1;
        }
        SoSeparator* root = SoDB::readAll(&input);
        if (NULL == root) {
          std::cout << "Failed to read file" << std::endl;
          return 1;
        }
        root->ref();
        printf("type id: %s\\n", root->getChild(0)->getTypeId().getName().getString());
        if (!root->getChild(0)->isOfType(SoCube::getClassTypeId())) {
          std::cout << "type mismatch" << std::endl;
          return 1;
        }
        printf("name: %s\\n", root->getChild(0)->getName().getString());
        if (0 != strcmp(root->getChild(0)->getName().getString(), "test")) {
          std::cout << "name mismatch" << std::endl;
          return 1;
        }
        root->unref();
        return 0;
      }
    EOS
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "./testCoin", testpath/"test.iv"
    end
  end
end
