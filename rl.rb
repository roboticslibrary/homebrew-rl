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
