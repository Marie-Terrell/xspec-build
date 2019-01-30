# These are the values to change
# Note, a patch file contains all the patches up to the one in the version string
# Comment out XSPEC_PATCH if you don't want any patches.
XSPEC_HEASOFT_VERSION="6.24";

XSPEC_PATCH="Xspatch_121000e.tar.gz";
XSPEC_PATCH_INSTALLER="patch_install_4.9.tcl";
XSPEC_MODELS_ONLY=heasoft-${XSPEC_HEASOFT_VERSION}

# Ok, start building XSPEC

XSPEC_DIST=/tmp/Xspec
XSPEC_DIR=$RECIPE_DIR/../../

cd $XSPEC_DIR 

# Download and extract the source code package
curl -LO -z ${XSPEC_MODELS_ONLY}src.tar.gz http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/lheasoft${XSPEC_HEASOFT_VERSION}/${XSPEC_MODELS_ONLY}src.tar.gz;
tar xf ${XSPEC_MODELS_ONLY}src.tar.gz;

# If a patch is required, download the necessary file and apply it
if [ -n "$XSPEC_PATCH" ]
then
    cd ${XSPEC_MODELS_ONLY}/Xspec/src;
    curl -LO -z ${XSPEC_PATCH} http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/archive/${XSPEC_PATCH};
    curl -LO -z ${XSPEC_PATCH_INSTALLER} http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/archive/${XSPEC_PATCH_INSTALLER};
    tclsh ${XSPEC_PATCH_INSTALLER} -m -n;
    rm -rf XSFits;
    cd ${XSPEC_DIR};
fi

#Copy in the OGIPTable fix
cp OGIPTable.cxx ${XSPEC_MODELS_ONLY}/Xspec/src/XSModel/Model/Component/OGIPTable

# Now for the actual build
cd ${XSPEC_DIR}/${XSPEC_MODELS_ONLY}/BUILD_DIR

# Set some compiler flags
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-std=c++11 -Wno-c++11-narrowing -I$CONDA_PREFIX/include"
export LDFLAGS="$LDFLAGS -L$CONDA_PREFIX/lib -Wl,--no-as-needed"

# Patch the configure script so XSModel is built
sed -i.orig "s|src/XSFunctions|src/XSFunctions src/XSModel|g" configure

# Do it.
./configure --prefix=$XSPEC_DIST --enable-xs-models-only --disable-x
make HD_ADD_SHLIB_LIBS=yes
make install

# We install in a temporary location, then we have to pick what we need for the package
# I.E. the libraries and the data files.
mkdir -p $PREFIX/lib
cp -L $XSPEC_DIST/x86*/lib/*.so* $PREFIX/lib/
cp -L $XSPEC_DIST/x86*/lib/*.a $PREFIX/lib/

mkdir -p $PREFIX/include
cp -L $XSPEC_DIST/x86*/include/xsFortran.h $PREFIX/include
cp -L $XSPEC_DIST/x86*/include/xsTypes.h $PREFIX/include
cp -L $XSPEC_DIST/x86*/include/funcWrappers.h $PREFIX/include


mkdir $PREFIX/Xspec
cp -R $XSPEC_DIST/spectral $PREFIX/Xspec/

