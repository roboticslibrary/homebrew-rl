class Coin < Formula
  desc "High-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://github.com/coin3d/coin"
  version "4.0.0-2"

  stable do
    url "https://github.com/coin3d/coin.git", revision: "07d438c5e0de005d1eee929caf22df6cb7f17ec3"
  end

  bottle do
    root_url "https://dl.bintray.com/roboticslibrary/bottles-rl"
    cellar :any
    sha256 "cd89294dfc580af37ba059fd067cef04a1fa82d75b8ba2f70d232e2fbb1f4bce" => :catalina
    sha256 "ef8163945469309ba603dce053b22709f362983fe614060e80e4be05897d028c" => :mojave
  end

  head do
    url "https://github.com/coin3d/coin.git"
  end

  depends_on "cmake" => :build

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
      \#Inventor V1.0 ascii
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
