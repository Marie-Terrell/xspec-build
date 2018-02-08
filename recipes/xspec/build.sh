
XSPEC_DIST=$PREFIX/Xspec
XSPEC_DIR=$RECIPE_DIR/../../

cd $XSPEC_DIR 

XSPEC_HEASOFT_VERSION="6.21";

# Note, a patch file contains all the patches up to the one in the version string
XSPEC_PATCH="Xspatch_120901u.tar.gz";
XSPEC_PATCH_INSTALLER="patch_install_4.8.tcl";
XSPEC_MODELS_ONLY=xspec-modelsonly-v${XSPEC_HEASOFT_VERSION}

wget -N http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/lheasoft${XSPEC_HEASOFT_VERSION}/${XSPEC_MODELS_ONLY}.tar.gz;
tar xf ${XSPEC_MODELS_ONLY}.tar.gz;

if [ -n "$XSPEC_PATCH" ]
then
    wget -N http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH} -P ${XSPEC_MODELS_ONLY}/Xspec/src;
    wget -N http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH_INSTALLER} -P ${XSPEC_MODELS_ONLY}/Xspec/src;
    cd ${XSPEC_MODELS_ONLY}/Xspec/src;
    tclsh ${XSPEC_PATCH_INSTALLER} -m -n;
    rm -rf XSFits;
    cd ${XSPEC_DIR};
fi

cd ${XSPEC_DIR}/${XSPEC_MODELS_ONLY}/BUILD_DIR

./configure --prefix=$XSPEC_DIST

sed -i.orig "s|XSLM_USER_FLAGS=\"\"|XSLM_USER_FLAGS=\"-I$PREFIX/include\"|g" ../Xspec/BUILD_DIR/hmakerc
sed -i.orig "s|XSLM_USER_LIBS=\"\"|XSLM_USER_LIBS=\"-L$PREFIX/lib\"|g" ../Xspec/BUILD_DIR/hmakerc

make

make install;

#cd ../;
#
#if [ ! -e install ]; then ln -s x86_64* install; fi;
#cp -r $XSPEC_DIR/xspec-modelsonly/spectral $XSPEC_DIST/lib
#cp $XSPEC_DIR/xspec-modelsonly/install/lib/* $XSPEC_DIST/lib
