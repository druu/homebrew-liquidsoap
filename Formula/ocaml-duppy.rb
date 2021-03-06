require 'formula'

class OcamlDuppy < Formula
  homepage 'http://liquidsoap.fm/'
  url 'http://downloads.sourceforge.net/project/savonet/ocaml-duppy/0.5.1/ocaml-duppy-0.5.1.tar.gz'
  sha256 'f34778e2d7ce131472f851fdd2adb4623b520d25b4609142e22070af0be5f293'

  depends_on 'objective-caml' => :build
  depends_on 'camlp4' => :build
  depends_on 'ocaml-findlib' => :build
  depends_on 'ocaml-pcre' => :build

  def install
    ENV.j1
    ENV.append "OCAMLPATH", "#{HOMEBREW_PREFIX}/lib/ocaml/site-lib"
    ENV.append "OCAMLFIND_DESTDIR", "#{lib}/ocaml/site-lib"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    mkdir_p "#{lib}/ocaml/site-lib"
    system "make install OCAMLFIND_LDCONF=ignore"
    Dir.glob("#{lib}/ocaml/site-lib/**/*stubs.so").each { |so| mkdir_p "#{lib}/ocaml/stublibs"; mv so, "#{lib}/ocaml/stublibs/" }
  end
end
