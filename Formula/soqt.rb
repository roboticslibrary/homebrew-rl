class Soqt < Formula
  desc "Qt GUI component toolkit library for Coin"
  homepage "https://bitbucket.org/Coin3D/soqt"
  version "1.6.0a-1"

  stable do
    url "https://bitbucket.org/Coin3D/soqt/get/9394e5e3aeaf.tar.gz"
    sha256 "bbdc1c02d14d83fcae425d4f620d5e44c2c83a747eafb0287a042699e67478bb"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/cf223b81fd77.tar.gz"
      sha256 "dab707c42138b42c0e1cc9bbae6a087004ab4717ec76a69b5b8dc20ac5b412ba"
    end
    resource "soanydata" do
      url "https://bitbucket.org/Coin3D/soanydata/get/f429a8af8628.tar.gz"
      sha256 "f77ef2484e71a96d50693e354ad544cced88abd7adb389a9459f26e6c7844119"
    end
    resource "sogui" do
      url "https://bitbucket.org/Coin3D/sogui/get/04d1d8732971.tar.gz"
      sha256 "a1994750414a16e285d4a08df64fedf98479bd826af19bb4b71f11c24118e95b"
    end
  end

  head do
    url "https://bitbucket.org/Coin3D/soqt/get/default.tar.gz"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/default.tar.gz"
    end
    resource "soanydata" do
      url "https://bitbucket.org/Coin3D/soanydata/get/default.tar.gz"
    end
    resource "sogui" do
      url "https://bitbucket.org/Coin3D/sogui/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "coin"
  depends_on "qt"

  def install
    resource("cpack.d").stage do
      cp_r Dir.pwd, buildpath/"cpack.d"
    end
    resource("soanydata").stage do
      cp_r Dir.pwd, buildpath/"data"
    end
    resource("sogui").stage do
      cp_r Dir.pwd, buildpath/"src/Inventor/Qt/common"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DSOQT_BUILD_DOCUMENTATION=OFF"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
