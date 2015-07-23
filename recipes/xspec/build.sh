XSPEC_DIST=$PREFIX/Xspec
XSPEC_DIR=$RECIPE_DIR/../../

# REMOVE WHEN READY
cd $XSPEC_DIR 

XSPEC_HEASOFT_VERSION="6.16";
XSPEC_PATCH="Xspatch_120802q.tar.gz";
XSPEC_PATCH_INSTALLER="patch_install_4.6.tcl";

wget -N http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/lheasoft${XSPEC_HEASOFT_VERSION}/xspec-modelsonly.tar.gz;
tar xf xspec-modelsonly.tar.gz;

wget -N http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH} -P xspec-modelsonly/Xspec/src;
wget -N http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH_INSTALLER} -P xspec-modelsonly/Xspec/src;
cd xspec-modelsonly/Xspec/src;
tclsh ${XSPEC_PATCH_INSTALLER} -m -n;
rm -rf XSFits;
cd ../../BUILD_DIR;
./configure --prefix=$XSPEC_DIST
make

make install;

#cd ../;
#
#if [ ! -e install ]; then ln -s x86_64* install; fi;
#cp -r $XSPEC_DIR/xspec-modelsonly/spectral $XSPEC_DIST/lib
#cp $XSPEC_DIR/xspec-modelsonly/install/lib/* $XSPEC_DIST/lib
