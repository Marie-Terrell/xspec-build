CCFITS_VER=2.4

wget -N http://heasarc.gsfc.nasa.gov/fitsio/ccfits/CCfits-${CCFITS_VER}.tar.gz 
tar xf CCfits-${CCFITS_VER}.tar.gz;

cd CCfits

./configure --prefix=$PREFIX --with-cfitsio=$PREFIX
make
make install

