
XSPEC_DIST=$PREFIX/Xspec
XSPEC_DIR=$RECIPE_DIR/../../

cd $XSPEC_DIR 

XSPEC_HEASOFT_VERSION="6.24";

# Note, a patch file contains all the patches up to the one in the version string
XSPEC_PATCH="Xspatch_121000e.tar.gz";
XSPEC_PATCH_INSTALLER="patch_install_4.9.tcl";
XSPEC_MODELS_ONLY=heasoft-${XSPEC_HEASOFT_VERSION}

curl -LO -z ${XSPEC_MODELS_ONLY}src.tar.gz http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/lheasoft${XSPEC_HEASOFT_VERSION}/${XSPEC_MODELS_ONLY}src.tar.gz;
tar xf ${XSPEC_MODELS_ONLY}src.tar.gz;

if [ -n "$XSPEC_PATCH" ]
then
    cd ${XSPEC_MODELS_ONLY}/Xspec/src;
    curl -LO -z ${XSPEC_PATCH} http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH};
    curl -LO -z ${XSPEC_PATCH_INSTALLER} http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH_INSTALLER};
    tclsh ${XSPEC_PATCH_INSTALLER} -m -n;
    rm -rf XSFits;
    cd ${XSPEC_DIR};
fi

cd ${XSPEC_DIR}/${XSPEC_MODELS_ONLY}/BUILD_DIR

#export CFLAGS='-I${PREFIX}/include -O2 -Wall --pedantic -Wno-comment -Wno-long-long -g  -ffloat-store -fPIC'
#export CXXFLAGS='-I${PREFIX}/include -O2 -Wall --pedantic -Wno-comment -Wno-long-long -g  -ffloat-store -fPIC'
#export CPPFLAGS="-I${PREFIX}/include"
#export LDFLAGS="-L${PREFIX}/lib" 

export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-std=c++11 -Wno-c++11-narrowing -I$CONDA_PREFIX/include"
export LDFLAGS="$LDFLAGS -L$CONDA_PREFIX/lib -Wl,--no-as-needed"

./configure --prefix=$XSPEC_DIST --enable-xs-models-only --disable-x --disable-ldopt

#./hmake 'XSLM_USER_FLAGS="-I${PREFIX}/include"' 'XSLM_USER_LIBS="-L${PREFIX}/lib -lCCfits -lcfitsio -lwcs"'
#./hmake 'XSLM_USER_FLAGS="-I${PREFIX}/include"' 'LDFLAGS_CXX=-headerpad_max_install_names -L$PREFIX/lib -lcfitsio -lCCfits -lccfits -lwcs' 'CXXFLAGS=-I$PREFIX/include -std=c++11 -Wno-c++11-narrowing'
make
make install

#cd ../;
#
#if [ ! -e install ]; then ln -s x86_64* install; fi;
#cp -r $XSPEC_DIR/xspec-modelsonly/spectral $XSPEC_DIST/lib
#cp $XSPEC_DIR/xspec-modelsonly/install/lib/* $XSPEC_DIST/lib
