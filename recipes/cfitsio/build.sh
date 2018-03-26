CFITSIO_VER=3370

wget -N ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio${CFITSIO_VER}.tar.gz 
tar xf cfitsio${CFITSIO_VER}.tar.gz;

cd cfitsio

./configure --prefix=$PREFIX
make shared
make install

