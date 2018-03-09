class Soqt < Formula
  desc "A Qt GUI component toolkit library for Coin"
  homepage "https://bitbucket.org/Coin3D/soqt"
  url "https://bitbucket.org/Coin3D/soqt/get/945ec22f62191d37838ba13fd66a26415ac3e0b5.tar.gz"
  sha256 "aaec649da36c8e450e4f8b1797cdd28a268d57119a3a813f68732ab9546cec54"
  version "1.6.0a"
  head "https://bitbucket.org/Coin3D/soqt/get/default.tar.gz"

  if !build.head?
    resource "sogui" do
      url "https://bitbucket.org/Coin3D/sogui/get/4f99ace822370b4f0e28ff23a527c4b30405673d.tar.gz"
      sha256 "cc7d215f56c0eb02394c2e97a6b7b5aa94df134938e230cd0f728431ca33cabd"
    end
  else
    resource "sogui" do
      url "https://bitbucket.org/Coin3D/sogui/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "coin"
  depends_on "qt"

  def install
    resource("sogui").stage do
      @soguipath = Dir.pwd
      system "cp", "-a", "#{@soguipath}", buildpath/"src/Inventor/Qt/common"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
