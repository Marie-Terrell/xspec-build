# These are the values to change
# Note, a patch file contains all the patches up to the one in the version string
# Comment out XSPEC_PATCH if you don't want any patches.
XSPEC_HEASOFT_VERSION="6.24";

XSPEC_PATCH="Xspatch_121000e.tar.gz";
XSPEC_PATCH_INSTALLER="patch_install_4.9.tcl";
XSPEC_MODELS_ONLY=heasoft-${XSPEC_HEASOFT_VERSION}

# Ok, start building XSPEC

XSPEC_DIST=$PREFIX/Xspec
XSPEC_DIR=$RECIPE_DIR/../../

cd $XSPEC_DIR 

# Download and extract the source code package
curl -LO -z ${XSPEC_MODELS_ONLY}src.tar.gz http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/lheasoft${XSPEC_HEASOFT_VERSION}/${XSPEC_MODELS_ONLY}src.tar.gz;
tar xf ${XSPEC_MODELS_ONLY}src.tar.gz;

# If a patch is required, download the necessary file and apply it
if [ -n "$XSPEC_PATCH" ]
then
    cd ${XSPEC_MODELS_ONLY}/Xspec/src;
    curl -LO -z ${XSPEC_PATCH} http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH};
    curl -LO -z ${XSPEC_PATCH_INSTALLER} http://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/issues/${XSPEC_PATCH_INSTALLER};
    tclsh ${XSPEC_PATCH_INSTALLER} -m -n;
    rm -rf XSFits;
    cd ${XSPEC_DIR};
fi

# Now for the actual build
cd ${XSPEC_DIR}/${XSPEC_MODELS_ONLY}/BUILD_DIR

# Set some compiler flags
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-std=c++11 -Wno-c++11-narrowing -I$CONDA_PREFIX/include"
export LDFLAGS="$LDFLAGS -L$CONDA_PREFIX/lib -Wl,--no-as-needed"

# Patch the configure script so XSModel is built
sed -i orig "|src/XSFunctions|src/XSFunctions src/XSModel|g"

# Do it.
./configure --prefix=$XSPEC_DIST --enable-xs-models-only --disable-x
make HD_ADD_SHLIB_LIBS=yes
make install

