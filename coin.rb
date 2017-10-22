class Coin < Formula
  desc "A high-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://bitbucket.org/Coin3D/coin"
  url "https://bitbucket.org/Coin3D/coin/get/a37c8fba8d0178cbb7806f609f2c1d4f59744b44.tar.gz"
  sha256 "b99e0ca960a0643ca34ad73cb537ebab52510537498f76b4fd53ab7af3992693"
  version "4.0.0a"
  head "https://bitbucket.org/Coin3D/coin/get/CMake.tar.gz"

  depends_on "cmake" => :build
  depends_on "simage" => :recommended

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCOIN_BUILD_DOCUMENTATION=OFF"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
