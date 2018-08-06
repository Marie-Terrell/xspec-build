
CXXFLAGS="-I$PREFIX/include -I$(pwd)/cookbook_hack"
LDFLAGS="-L$PREFIX/lib"

mkdir -p cookbook_hack/CCfits
cp *.h cookbook_hack/CCfits

./configure --prefix=$PREFIX
make
make install

