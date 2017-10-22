class Soqt < Formula
  desc "A Qt GUI component toolkit library for Coin"
  homepage "https://bitbucket.org/Coin3D/soqt"
  url "https://bitbucket.org/Coin3D/soqt/get/788d47c185c867778d393bcd96c4ac529faee412.tar.gz"
  sha256 "2744ce35a6ade0104627d330087ccb46e4f3e0295d0f99cc47ed508ca3443d66"
  version "1.6.0a"
  head "https://bitbucket.org/Coin3D/soqt/get/default.tar.gz"

  if !build.head?
    resource "sogui" do
      url "https://bitbucket.org/Coin3D/sogui/get/bc52641c3d43115d88c11d15801e0c64996891ee.tar.gz"
      sha256 "58638e192eb594f51de0e2fd42b12105a0d4274167ccbeac5cc93f0763c44d0b"
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
