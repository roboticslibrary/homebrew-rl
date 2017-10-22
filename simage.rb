class Simage < Formula
  desc "A library with image format loaders and front-ends to common import libraries"
  homepage "https://bitbucket.org/Coin3D/simage"
  url "https://bitbucket.org/Coin3D/simage/get/cf953eacd8498009390e0fe0c2dd614ebf5d1024.tar.gz"
  sha256 "a214e75cfb1f20554c748578d4fdcca9bfaf004bc51e073cafe68b72b1a864a8"
  version "1.7.1a"
  head "https://bitbucket.org/Coin3D/simage/get/default.tar.gz"

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
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
