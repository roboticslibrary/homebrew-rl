class Rl < Formula
  desc "Self-contained C++ library for robot kinematics, motion planning and control"
  homepage "https://www.roboticslibrary.org/"
  head "https://github.com/roboticslibrary/rl/archive/master.tar.gz"

  stable do
    url "https://github.com/roboticslibrary/rl/archive/0.7.0.tar.gz"
    sha256 "0a8b4c45307dd607bd1c8f56d0f96d40855ad0a697a2642bf3b307c7eb1b3de5"
    patch do
      url "https://github.com/roboticslibrary/rl/commit/2398cea996dce6c54330d6562fa1079daa1a9d4a.patch?full_index=1"
      sha256 "848679985d67ed7ce5f26e92c1bbcc4013d876291a8b1ea4dfd8f0e6607b6688"
    end
    patch do
      url "https://github.com/roboticslibrary/rl/commit/8bfd262f7eaf23e298396ae0d3f7c360f20d2db1.patch?full_index=1"
      sha256 "5e736f8b7ffbc53c7973c6360a07bb57e89f33a7050eecf63c0acd28c8290ac8"
    end
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "coin"
  depends_on "eigen"
  depends_on "bullet" => :recommended
  depends_on "nlopt" => :recommended
  depends_on "ode" => :recommended
  depends_on "pqp" => :recommended
  depends_on "qt" => :recommended
  depends_on "solid" => :recommended
  depends_on "soqt" => :recommended

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.1)
      project(testRl)
      set(CMAKE_CXX_STANDARD 11)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      find_package(RL COMPONENTS MDL)
      add_executable(testRl testRl.cpp)
      target_link_libraries(testRl rl::mdl)
    EOS
    (testpath/"testRl.cpp").write <<~EOS
      #include <rl/mdl/Model.h>
      int main(int argc, char** argv) {
        rl::mdl::Model model;
        return 0;
      }
    EOS
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "./testRl"
    end
  end
end
