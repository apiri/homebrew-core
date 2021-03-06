class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.7.tar.xz"
  sha256 "56fc42a4afece57bc27f95a2d155815a5e6472f32535add4c0ab4ce3b5e399e7"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "6b1633f4e5f572c6358094ce4d14f40accb43cf4b827bff90cd919724eb1435c" => :catalina
    sha256 "d7ff08c8ed104c89b7463d1cbf6740fd15def9991355855bbe20fd51838b9332" => :mojave
    sha256 "69b7afc70b76386a35e6a63978a8c44f515fdabd19b1b1a3027162ede7a24a99" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libiconv"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python"
  depends_on "ruby"

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
