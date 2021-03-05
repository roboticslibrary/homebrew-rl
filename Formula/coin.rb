class Coin < Formula
  desc "High-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://github.com/coin3d/coin"
  version "4.0.0-3"

  stable do
    url "https://github.com/coin3d/coin.git", revision: "07d438c5e0de005d1eee929caf22df6cb7f17ec3"
  end

  bottle do
    root_url "https://dl.bintray.com/roboticslibrary/bottles-rl"
    sha256 cellar: :any, big_sur:  "2ab4775eef1a98b18343dd8875ae28f2577090c1bb605d765ddaba90554a797f"
    sha256 cellar: :any, catalina: "f72cb564f54fda1af43546612388de1821df9d716360554483d83f1e652fcdb1"
    sha256 cellar: :any, mojave:   "3c3eb6be2de9f6ade03a5a2ca6aec79619602bd5bb3e78788e7b1d7b20e326f2"
  end

  head do
    url "https://github.com/coin3d/coin.git"
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
