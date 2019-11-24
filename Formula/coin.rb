class Coin < Formula
  desc "High-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://bitbucket.org/Coin3D/coin"
  version "4.0.0a-1"

  stable do
    url "https://bitbucket.org/Coin3D/coin/get/a4ce638f43bd.tar.gz"
    sha256 "fda0fdaa4537d3d5af9238ba6a3b38b7496813ae5dc872fa1cc4c11d84d69788"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/cf223b81fd77.tar.gz"
      sha256 "dab707c42138b42c0e1cc9bbae6a087004ab4717ec76a69b5b8dc20ac5b412ba"
    end
  end

  bottle do
    root_url "https://dl.bintray.com/roboticslibrary/bottles-rl"
    cellar :any
    sha256 "c601688f79068543f2746260d653e05e98f435be01a76955f4e5b2aa503670e9" => :catalina
    sha256 "4f039176121598d73f71407f99a598f3ab65c431d9eb3b68b4b8fe0df6057dee" => :mojave
  end

  head do
    url "https://bitbucket.org/Coin3D/coin/get/default.tar.gz"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "simage" => :recommended

  def install
    resource("cpack.d").stage do
      cp_r Dir.pwd, buildpath/"cpack.d"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCOIN_BUILD_DOCUMENTATION=OFF"
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
    (testpath/"testCoin.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        return 0;
      }
    EOS
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "./testCoin"
    end
  end
end
