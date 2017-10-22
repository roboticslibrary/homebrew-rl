class Pqp < Formula
  desc "A library for performing proximity queries on a pair of geometric models composed of triangles"
  homepage "https://github.com/GammaUNC/PQP"
  url "https://github.com/GammaUNC/PQP/archive/e583e835532a94511bf217e999a96952db8fea52.tar.gz"
  sha256 "233ce59c4358caf080c3d2295c0beb2631e0b877a8c3209f401d28c40ea181f6"
  version "1.3"
  head "https://github.com/GammaUNC/PQP/archive/master.tar.gz"

  patch do
    url "https://github.com/GammaUNC/PQP/pull/1.diff"
  end

  depends_on "cmake" => :build

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
