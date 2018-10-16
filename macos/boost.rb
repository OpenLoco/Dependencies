class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  revision 1
  head "https://github.com/boostorg/boost.git"

  bottle do
    root_url "https://github.com/OpenRCT2/OpenLoco-Dependencies/releases/download/v1.1.0/"
    cellar :any
    rebuild 1
    sha256 "b92dd2586ca68d3db5011ac2c7dbfab2b3b5f77961194c3846d3d3f699f6735b" => :sierra
    sha256 "a56b297000c596267bd9fc01984338c9e2f20f4887fbeb925140842aa1e0c7c3" => :high_sierra
  end

  stable do
    url "https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2"
    sha256 "2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba"

    # Remove for > 1.67.0
    # Fix "error: no member named 'next' in namespace 'boost'"
    # Upstream commit from 1 Dec 2017 "Add #include <boost/next_prior.hpp>; no
    # longer in utility.hpp"
    patch :p2 do
      url "https://github.com/boostorg/lockfree/commit/12726cd.patch?full_index=1"
      sha256 "f165823d961a588b622b20520668b08819eb5fdc08be7894c06edce78026ce0a"
    end
  end

  option "with-icu4c", "Build regexp engine with icu support"
  option "without-single", "Disable building single-threading variant"
  option "without-static", "Disable building static library variant"

  deprecated_option "with-icu" => "with-icu4c"

  depends_on "icu4c" => :optional

  needs :cxx11

  def install
    ENV.universal_binary

    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} : <cxxflags>\"-arch x86_64 -arch i386\" ;\n"
    end

    # libdir should be set by --prefix but isn't
    bootstrap_args = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? "icu4c"
      icu4c_prefix = Formula["icu4c"].opt_prefix
      bootstrap_args << "--with-icu=#{icu4c_prefix}"
    else
      bootstrap_args << "--without-icu"
    end

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    without_libraries << "context"
    # The coroutine library depends on the context library.
    without_libraries << "coroutine"

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--with-libraries=filesystem"

    # layout should be synchronized with boost-python and boost-mpi
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "-sNO_LZMA=1",
            "install"]

    if build.with? "single"
      args << "threading=multi,single"
    else
      args << "threading=multi"
    end

    if build.with? "static"
      args << "link=shared,static"
    else
      args << "link=shared"
    end

    args << "address-model=32_64" << "architecture=x86" << "pch=off"

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++11"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  def caveats
    s = ""
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
      s += <<~EOS
        Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    s
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-lboost_system", "-o", "test"
    system "./test"
  end
end
