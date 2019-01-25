class Soqt < Formula
  desc "A Qt GUI component toolkit library for Coin"
  homepage "https://bitbucket.org/Coin3D/soqt"
  url "https://bitbucket.org/Coin3D/soqt/get/c654fc427542.tar.gz"
  sha256 "59f4030883e35cf1e9f4dc30429df6ff0f23c5420d61b7b19894b59beaa22ac5"
  version "1.6.0a"
  head "https://bitbucket.org/Coin3D/soqt/get/default.tar.gz"

  if !build.head?
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/7a4972d58197.tar.gz"
      sha256 "333b75ed3fe1d22d6ab54256b2b09fa8c1c530170c20a55f57254afd05784204"
    end
    resource "soanydata" do
      url "https://bitbucket.org/Coin3D/soanydata/get/f8721d842e1d.tar.gz"
      sha256 "5220f59ea7bdbaad28f50640ca384db8592f1d4767664531f7a25ce88e630485"
    end
    resource "sogui" do
      url "https://bitbucket.org/Coin3D/sogui/get/04d1d8732971.tar.gz"
      sha256 "a1994750414a16e285d4a08df64fedf98479bd826af19bb4b71f11c24118e95b"
    end
  else
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
      @cpackdpath = Dir.pwd
      system "cp", "-a", "#{@cpackdpath}", buildpath/"cpack.d"
    end
    resource("soanydata").stage do
      @soanydatapath = Dir.pwd
      system "cp", "-a", "#{@soanydatapath}", buildpath/"data"
    end
    resource("sogui").stage do
      @soguipath = Dir.pwd
      system "cp", "-a", "#{@soguipath}", buildpath/"src/Inventor/Qt/common"
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
