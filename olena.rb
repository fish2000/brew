
# Original formula by @glazzara
# Adapted from https://github.com/Homebrew/homebrew/pull/16092/files

class Olena < Formula
  homepage 'http://olena.lrde.epita.fr'
  
  #url 'http://www.lrde.epita.fr/dload/olena/2.0/olena-2.0a.tar.gz'
  #version "2.0"
  #sha1 'a9445bac1f30c9d999ad5ce70588745e153700dd'
  
  url 'https://www.lrde.epita.fr/dload/olena/2.1/olena-2.1.tar.bz2'
  version "2.1.0"
  sha1 '54f756b033a45d4c2fe1233c10fc43f99f9f552f'
  
  option :cxx11
  option "without-tesseract", "Disable Tesseract OCR Support"
  option "without-tiff", "Disable TIFF Image Format Support"
  option "with-scribo", "Enable Scribo Support (Whatever The F That Is)"
  
  depends_on 'libxslt'
  depends_on 'libtiff' => :optional
  depends_on 'tesseract' => :optional
  
  depends_on 'graphicsmagick'
  depends_on 'fop'
  depends_on 'qt'

  def install
    ENV.cxx11 if build.cxx11?
    ENV.append_to_cppflags "-I/usr/local/include/GraphicsMagick"
    ENV.append_to_cppflags "-DHAVE_SYS_TYPES_H=1"
    ENV.append_to_cxxflags "-fno-strict-aliasing"
    #ENV.append_to_ldflags "-L /some/shit"
    
    cargs = [
      "QT_PATH=/usr/local", "QMAKE=/usr/local/bin/qmake",
                            "MOC=/usr/local/bin/moc", 
                            "UIC=/usr/local/bin/uic",
                            "RCC=/usr/local/bin/rcc",
      "--with-graphicsmagickxx=#{Formula['graphicsmagick'].opt_prefix}",
      "--with-imagemagickxx=no"]
    
    cargs << "--with-tiff=#{Formula['libtiff'].opt_prefix}" if not build.without? "tiff"
    cargs << "--with-tesseract=#{Formula['tesseract'].opt_prefix}" if not build.without? "tesseract"
    cargs << "--enable-scribo" if build.with? "scribo"
    
    system "./configure", "--prefix=#{prefix}", *cargs
    system "make" 
    system "make install"
  end
end