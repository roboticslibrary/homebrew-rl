class Soqt < Formula
  desc "Qt GUI component toolkit library for Coin"
  homepage "https://github.com/coin3d/soqt"
  version "1.6.0-3"

  stable do
    url "https://github.com/coin3d/soqt.git", revision: "6b1c74fbc83c7ef4bcc3f23742ba04fa5b6cf350"
  end

  bottle do
    root_url "https://www.roboticslibrary.org/bottles-rl"
    sha256 cellar: :any, big_sur:  "9f22f48c9d500fab32b25c4ba72b8ee67fc61404ff4090feaa654c8eb2e4911a"
    sha256 cellar: :any, catalina: "b6286af84576e67e7d1fc57fa93dca5367c12324151bd569a48d107a90e0557c"
    sha256 cellar: :any, mojave:   "e56e2fbc0eb54f032a40ca881fb6feec51a418d5a649beb2f69395848d728eef"
  end

  head do
    url "https://github.com/coin3d/soqt.git"
  end

  depends_on "cmake" => :build
  depends_on "coin"
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DSOQT_BUILD_DOCUMENTATION=OFF", "-DSOQT_BUILD_TESTS=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(testSoQt)
      find_package(SoQt)
      add_executable(testSoQt testSoQt.cpp)
      target_link_libraries(testSoQt SoQt::SoQt)
    EOS
    (testpath/"testSoQt.cpp").write <<~EOS
      #include <iostream>
      #include <Inventor/SoDB.h>
      #include <Inventor/Qt/SoQt.h>
      #include <Inventor/Qt/viewers/SoQtExaminerViewer.h>
      #include <QWidget>
      int main(int argc, char** argv) {
        SoDB::init();
        QWidget* widget = SoQt::init(argc, argv, argv[0]);
        if (NULL == widget) {
          std::cout << "Could not initialize widget" << std::endl;
          return 1;
        }
        SoQtExaminerViewer* viewer = new SoQtExaminerViewer(widget);
        SbColor color(0.5f, 0.5f, 0.5f);
        viewer->setBackgroundColor(color);
        if (!viewer->getBackgroundColor().equals(color, 1.0e-6f)) {
          std::cout << "Could not set background color" << std::endl;
          delete widget;
          return 1;
        }
        delete viewer;
        delete widget;
        return 0;
      }
    EOS
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "./testSoQt"
    end
  end
end
