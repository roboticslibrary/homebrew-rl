class Rl < Formula
  desc "A self-contained C++ library for robot kinematics, motion planning and control"
  homepage "https://www.roboticslibrary.org/"
  url "https://github.com/roboticslibrary/rl/archive/0.7.0.tar.gz"
  sha256 "0a8b4c45307dd607bd1c8f56d0f96d40855ad0a697a2642bf3b307c7eb1b3de5"
  version "0.7.0"
  head "https://github.com/roboticslibrary/rl/archive/master.tar.gz"

  depends_on "boost"
  depends_on "bullet" => :recommended
  depends_on "cmake" => :build
  depends_on "coin"
  depends_on "eigen"
  depends_on "nlopt" => [:recommended, "without-numpy"]
  depends_on "ode" => :recommended
  depends_on "pqp" => :recommended
  depends_on "qt" => :recommended
  depends_on "solid" => :recommended
  depends_on "soqt" => :recommended

  stable do
    patch do
      url "https://github.com/roboticslibrary/rl/commit/2398cea996dce6c54330d6562fa1079daa1a9d4a.patch"
      sha256 "13ffdf2d9ad3f031752d640babc4040d38876784c23c48ba7c50c6c1a0175e29"
    end
    patch do
      url "https://github.com/roboticslibrary/rl/commit/8bfd262f7eaf23e298396ae0d3f7c360f20d2db1.patch"
      sha256 "4bc0a110ad883af7e90a28717dabd0a473b27dd648fc1d264e16cef57375d625"
    end
  end

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
