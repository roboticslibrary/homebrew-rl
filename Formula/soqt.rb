class Soqt < Formula
  desc "Qt GUI component toolkit library for Coin"
  homepage "https://github.com/coin3d/soqt"
  url "https://github.com/coin3d/soqt/releases/download/v1.6.2/soqt-1.6.2-src.tar.gz"
  sha256 "fb483b20015ab827ba46eb090bd7be5bc2f3d0349c2f947c3089af2b7003869c"
  head "https://github.com/coin3d/soqt.git", branch: "master"

  bottle do
    root_url "https://www.roboticslibrary.org/bottles-rl"
    sha256 cellar: :any, sonoma:   "41596bd1d219a877b66147462d06c38a3fed549c165d09f36447ae552a70d8fb"
    sha256 cellar: :any, ventura:  "84745b4c001cc307f4cd95235fd3aad02bb685f04d34c8c32b54ca17c82ee367"
    sha256 cellar: :any, monterey: "09aa52665a4e24579c3b739375217cb1658539e002c497ae8d8ba126a4467593"
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
