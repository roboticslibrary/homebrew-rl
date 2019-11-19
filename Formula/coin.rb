class Coin < Formula
  desc "High-level, retained-mode toolkit for effective 3D graphics development"
  homepage "https://bitbucket.org/Coin3D/coin"
  version "4.0.0a-1"

  stable do
    url "https://bitbucket.org/Coin3D/coin/get/a4ce638f43bd.tar.gz"
    sha256 "fda0fdaa4537d3d5af9238ba6a3b38b7496813ae5dc872fa1cc4c11d84d69788"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/cf223b81fd77.tar.gz"
      sha256 "dab707c42138b42c0e1cc9bbae6a087004ab4717ec76a69b5b8dc20ac5b412ba"
    end
  end

  head do
    url "https://bitbucket.org/Coin3D/coin/get/default.tar.gz"
    resource "cpack.d" do
      url "https://bitbucket.org/Coin3D/cpack.d/get/default.tar.gz"
    end
  end

  depends_on "cmake" => :build
  depends_on "simage" => :recommended

  def install
    resource("cpack.d").stage do
      cp_r Dir.pwd, buildpath/"cpack.d"
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
