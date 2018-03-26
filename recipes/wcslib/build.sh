WCSLIB_VER=5.18

wget -N ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib.tar.bz2
tar xf wcslib.tar.bz2

cd wcslib-$WCSLIB_VER

./configure --prefix=$PREFIX
make
make install

