class Pqp < Formula
  desc "Library for performing proximity queries on a pair of triangle meshes"
  homepage "https://github.com/GammaUNC/PQP"
  url "https://github.com/GammaUNC/PQP/archive/e583e835532a94511bf217e999a96952db8fea52.tar.gz"
  version "1.3"
  sha256 "233ce59c4358caf080c3d2295c0beb2631e0b877a8c3209f401d28c40ea181f6"
  head "https://github.com/GammaUNC/PQP/archive/master.tar.gz"

  depends_on "cmake" => :build

  patch do
    url "https://github.com/GammaUNC/PQP/pull/1.diff?full_index=1"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 2.8.11)
      project(testPqp)
      find_package(PQP)
      add_executable(testPqp testPqp.cpp)
      target_link_libraries(testPqp PQP::PQP)
    EOS
    (testpath/"testPqp.cpp").write <<~EOS
      #include <PQP.h>
      int main() {
        PQP_REAL p0[3] = { 0.0f, 0.0f, 0.0f };
        PQP_REAL p1[3] = { 1.0f, 0.0f, 0.0f };
        PQP_REAL p2[3] = { 0.0f, 1.0f, 0.0f };
        PQP_Model model;
        model.BeginModel(1);
        model.AddTri(p0, p1, p2, 0);
        model.EndModel();
        return 0;
      }
    EOS
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "./testPqp"
    end
  end
end
