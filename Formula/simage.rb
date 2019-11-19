class Simage < Formula
  desc "A library with image format loaders and front-ends to common import libraries"
  homepage "https://bitbucket.org/Coin3D/simage"
  url "https://bitbucket.org/Coin3D/simage/get/146ceef3b157.tar.gz"
  sha256 "9e0334b2ddaae540857dd50b41cf971bf7fee90cc421973848416dfef9fca3d9"
  version "1.7.1a"
  head "https://bitbucket.org/Coin3D/simage/get/default.tar.gz"

  stable do
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/7a4972d58197.tar.gz"
      sha256 "333b75ed3fe1d22d6ab54256b2b09fa8c1c530170c20a55f57254afd05784204"
    end
  end

  head do
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "giflib" => :optional
  depends_on "jasper" => :optional
  depends_on "jpeg" => :optional
  depends_on "libpng" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libtiff" => :optional
  depends_on "libvorbis" => :optional
  depends_on "qt" => :optional

  def install
    resource("cpack.d").stage do
      @cpackdpath = Dir.pwd
      system "cp", "-a", "#{@cpackdpath}", buildpath/"cpack.d"
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
