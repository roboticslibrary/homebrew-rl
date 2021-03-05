class Soqt < Formula
  desc "Qt GUI component toolkit library for Coin"
  homepage "https://github.com/coin3d/soqt"
  version "1.6.0-3"

  stable do
    url "https://github.com/coin3d/soqt.git", revision: "6b1c74fbc83c7ef4bcc3f23742ba04fa5b6cf350"
  end

  bottle do
    root_url "https://dl.bintray.com/roboticslibrary/bottles-rl"
    sha256 cellar: :any, big_sur:  "43f7505c30e430b0f4a0810c70c0c619efef220b9b7fcfd7e56d47415b5785e0"
    sha256 cellar: :any, catalina: "a5229502e1c2b0a3d857c07f6c101ca890f29689c3e12ffe2bac036ce6c9da3a"
    sha256 cellar: :any, mojave:   "7a9f9824c5133f82cd30d1b413deed5a7942a6ad169cee27dabba876417d138f"
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
