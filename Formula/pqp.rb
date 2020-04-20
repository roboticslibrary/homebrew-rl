class Pqp < Formula
  desc "Library for performing proximity queries on a pair of triangle meshes"
  homepage "https://github.com/GammaUNC/PQP"
  url "https://github.com/GammaUNC/PQP.git", :revision => "713de5b70dd1849b915f6412330078a9814e01ab"
  version "1.3-1"
  head "https://github.com/GammaUNC/PQP.git"

  depends_on "cmake" => :build

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
      #include <iostream>
      #include <PQP.h>
      int main() {
        PQP_REAL p0[3] = { -1.0, 0.0, 0.0 };
        PQP_REAL p1[3] = { 1.0, 0.0, 0.0 };
        PQP_REAL p2[3] = { 0.0, 1.0, 0.0 };
        PQP_Model model;
        if (PQP_OK != model.BeginModel(1)) {
          std::cout << "Error in BeginModel" << std::endl;
          return 1;
        }
        if (PQP_OK != model.AddTri(p0, p1, p2, 0)) {
          std::cout << "Error in AddTri" << std::endl;
          return 1;
        }
        if (PQP_OK != model.EndModel()) {
          std::cout << "Error in EndModel" << std::endl;
          return 1;
        }
        PQP_REAL rotation0[3][3] = {
          { 1.0, 0.0, 0.0 },
          { 0.0, 1.0, 0.0 },
          { 0.0, 0.0, 1.0 }
        };
        PQP_REAL rotation1[3][3] = {
          { 1.0, 0.0, 0.0 },
          { 0.0, 0.0, -1.0 },
          { 0.0, 1.0, 0.0 }
        };
        PQP_REAL translation[3] = { 0.0, 0.0, 0.0 };
        PQP_CollideResult collideResult;
        if (PQP_OK != PQP_Collide(&collideResult, rotation0, translation, &model, rotation1, translation, &model, PQP_FIRST_CONTACT)) {
          std::cout << "Error in PQP_Collide" << std::endl;
          return 1;
        }
        if (!collideResult.Colliding()) {
          std::cout << "Error in collision test of intersecting triangles" << std::endl;
          return 1;
        }
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
