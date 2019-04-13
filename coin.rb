class Coin < Formula
  desc "A high-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://bitbucket.org/Coin3D/coin"
  url "https://bitbucket.org/Coin3D/coin/get/6c7a6ce6eed6.tar.gz"
  sha256 "13dc0be05ae8c65fa5994865d8c86faeec399e6b0233a61816126bfdb46ad4ea"
  version "4.0.0a"
  head "https://bitbucket.org/Coin3D/coin/get/default.tar.gz"

  stable do
    resource "boost-header-libs-full" do
      url "https://bitbucket.org/Coin3D/boost-header-libs-full/get/25bb7785a024.tar.gz"
      sha256 "58acfff2ee643328746c585bd9c890b0e55d7e50eaa310ccc3892f3fbd1e5701"
    end
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/7a4972d58197.tar.gz"
      sha256 "333b75ed3fe1d22d6ab54256b2b09fa8c1c530170c20a55f57254afd05784204"
    end
  end

  head do
    resource "boost-header-libs-full" do
      url "https://bitbucket.org/Coin3D/boost-header-libs-full/get/default.tar.gz"
    end
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "simage" => :recommended

  def install
    resource("boost-header-libs-full").stage do
      @boostheaderlibsfullpath = Dir.pwd
      system "cp", "-a", "#{@boostheaderlibsfullpath}", buildpath/"include/boost"
    end
    resource("cpack.d").stage do
      @cpackdpath = Dir.pwd
      system "cp", "-a", "#{@cpackdpath}", buildpath/"cpack.d"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCOIN_BUILD_DOCUMENTATION=OFF"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
