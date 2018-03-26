CCFITS_VER=2.5

wget -N http://heasarc.gsfc.nasa.gov/fitsio/ccfits/CCfits-${CCFITS_VER}.tar.gz 
tar xf CCfits-${CCFITS_VER}.tar.gz;

cd CCfits

CXXFLAGS="-I$PREFIX/include -L$PREFIX/lib"

./configure --prefix=$PREFIX
make
make install

