require 'formula'

class OcamlFfmpeg < Formula
  homepage 'http://liquidsoap.fm/'
  url 'http://downloads.sourceforge.net/project/savonet/ocaml-ffmpeg/0.1.0/ocaml-ffmpeg-0.1.0.tar.gz'
  sha256 'd1a24dc1e0ab2daa5baf307c91ede6691ef5c322d10f6ab0cbd5a4fa1b140848'

  depends_on 'objective-caml' => :build
  depends_on 'ocaml-findlib' => :build
  depends_on 'pkg-config' => :build
  depends_on 'ffmpeg' => :build

  def patches
      DATA
    end


  def install
    ENV.j1
    ENV.append "OCAMLFIND_DESTDIR", "#{lib}/ocaml/site-lib"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    mkdir_p "#{lib}/ocaml/site-lib"
    system "make install OCAMLFIND_LDCONF=ignore"
    Dir.glob("#{lib}/ocaml/site-lib/**/*stubs.so").each { |so| mkdir_p "#{lib}/ocaml/stublibs"; mv so, "#{lib}/ocaml/stublibs/" }
  end
end

__END__
--- liquidsoap-1.2.0-full/ocaml-ffmpeg-0.1.0/src/avutil_stubs.c	2015-08-03 17:47:57.000000000 +0200
+++ ocaml-ffmpeg/src/avutil_stubs.c	2016-03-26 17:11:26.000000000 +0100
@@ -10,22 +10,22 @@
 #include <libavutil/pixfmt.h>
 #include <libavutil/pixdesc.h>
 
-static const enum PixelFormat PIXEL_FORMATS[] = {
-  PIX_FMT_YUV420P,
-  PIX_FMT_YUYV422,
-  PIX_FMT_RGB24,
-  PIX_FMT_BGR24,
-  PIX_FMT_YUV422P,
-  PIX_FMT_YUV444P,
-  PIX_FMT_YUV410P,
-  PIX_FMT_YUV411P,
-  PIX_FMT_YUVJ422P,
-  PIX_FMT_YUVJ444P,
-  PIX_FMT_RGBA,
-  PIX_FMT_BGRA
+static const enum AVPixelFormat PIXEL_FORMATS[] = {
+  AV_PIX_FMT_YUV420P,
+  AV_PIX_FMT_YUYV422,
+  AV_PIX_FMT_RGB24,
+  AV_PIX_FMT_BGR24,
+  AV_PIX_FMT_YUV422P,
+  AV_PIX_FMT_YUV444P,
+  AV_PIX_FMT_YUV410P,
+  AV_PIX_FMT_YUV411P,
+  AV_PIX_FMT_YUVJ422P,
+  AV_PIX_FMT_YUVJ444P,
+  AV_PIX_FMT_RGBA,
+  AV_PIX_FMT_BGRA
 };
 
-int PixelFormat_val(value v)
+enum AVPixelFormat PixelFormat_val(value v)
 {
   return PIXEL_FORMATS[Int_val(v)];
 }
@@ -33,10 +33,10 @@
 CAMLprim value caml_avutil_bits_per_pixel(value pixel)
 {
   CAMLparam1(pixel);
-  int p = Int_val(pixel);
+  enum AVPixelFormat p = PixelFormat_val(pixel);
   int ans;
 
-  ans = av_get_bits_per_pixel(&av_pix_fmt_descriptors[p]);
+  ans = av_get_bits_per_pixel(av_pix_fmt_desc_get(p));
 
   CAMLreturn(Val_int(ans));
 }
--- liquidsoap-1.2.0-full/ocaml-ffmpeg-0.1.0/src/swscale_stubs.c	2015-08-03 17:47:57.000000000 +0200
+++ ocaml-ffmpeg/src/swscale_stubs.c	2016-03-26 17:11:26.000000000 +0100
@@ -90,10 +90,10 @@
   CAMLlocal1(ans);
   int src_w = Int_val(src_w_);
   int src_h = Int_val(src_h_);
-  enum PixelFormat src_format = PixelFormat_val(src_format_);
+  enum AVPixelFormat src_format = PixelFormat_val(src_format_);
   int dst_w = Int_val(dst_w_);
   int dst_h = Int_val(dst_h_);
-  enum PixelFormat dst_format = PixelFormat_val(dst_format_);
+  enum AVPixelFormat dst_format = PixelFormat_val(dst_format_);
   int flags = 0;
   int i;
   struct SwsContext *c;
