/*
   g++ -o nei nei.cc -Wall -L$HEADAS/lib -lXSFunctions -lXSUtil
-lXSModel -lXS -lwcs-4.20 -lCCfits_2.4 -lcfitsio_3.37 -lgfortran

try out several of the NEI models

*/

#include <iostream>

typedef void (*cpp_model_ptr)(const double* energy, int nFlux, const
double* params, int spectrumNumber, double* flux, double* fluxError,
const char* initStr);

typedef void (*f_model_ptr)(float* energy, int *nFlux, float* params,
int *spectrumNumber, float* flux, float* fluxError);

extern "C" {
  void FNINIT();
  char* FGSOLR();
  char* FGXSCT();
  void FPCHAT(int);

  void csmpq0(float q0);
  void csmph0(float H0);
  void csmpl0(float lambda0);

  int xs_getVersion(char *buffer, int buffSize);

  void C_gnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_nei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_rnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_vgnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_vnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_vrnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_vvgnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_vvnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void C_vvrnei(const double* energy, int nFlux, const double* params,
int spectrumNumber, double* flux, double* fluxError, const char*
initStr);

  void xszvab_(float* ear, int* ne, float* param, int* ifl, float*
photar, float* photer);

}

/***
vvnei has 33 parameters (ignoring norm)

In [2]: mdl = xspec.XSvvnei()

In [3]: print(mdl)
vvnei
   Param        Type          Value          Min          Max      Units
   -----        ----          -----          ---          ---      -----
   vvnei.kT     thawed            1       0.0808         79.9        keV
   vvnei.H      frozen            1            0         1000
   vvnei.He     frozen            1            0         1000
   vvnei.Li     frozen            1            0         1000
   vvnei.Be     frozen            1            0         1000
   vvnei.B      frozen            1            0         1000
   vvnei.C      frozen            1            0         1000
   vvnei.N      frozen            1            0         1000
   vvnei.O      frozen            1            0         1000
   vvnei.F      frozen            1            0         1000
   vvnei.Ne     frozen            1            0         1000
   vvnei.Na     frozen            1            0         1000
   vvnei.Mg     frozen            1            0         1000
   vvnei.Al     frozen            1            0         1000
   vvnei.Si     frozen            1            0         1000
   vvnei.P      frozen            1            0         1000
   vvnei.S      frozen            1            0         1000
   vvnei.Cl     frozen            1            0         1000
   vvnei.Ar     frozen            1            0         1000
   vvnei.K      frozen            1            0         1000
   vvnei.Ca     frozen            1            0         1000
   vvnei.Sc     frozen            1            0         1000
   vvnei.Ti     frozen            1            0         1000
   vvnei.V      frozen            1            0         1000
   vvnei.Cr     frozen            1            0         1000
   vvnei.Mn     frozen            1            0         1000
   vvnei.Fe     frozen            1            0         1000
   vvnei.Co     frozen            1            0         1000
   vvnei.Ni     frozen            1            0         1000
   vvnei.Cu     frozen            1            0         1000
   vvnei.Zn     frozen            1            0         1000
   vvnei.Tau    thawed        1e+11        1e+08        5e+13     s/cm^3
   vvnei.redshift frozen            0       -0.999           10
   vvnei.norm   thawed            1            0        1e+24

***/

// just to use the same grid as the python tests
const int nbins = 990;

void eval_model(cpp_model_ptr mfunc,
        double *params) {

  double energy[nbins];
  double flux[nbins];
  double fluxerr[nbins];
  int i;

  energy[0] = 0.1;
  flux[0] = 0.0;
  fluxerr[0] = 0.0;
  for (i=1; i < nbins; i++) {
    energy[i] = energy[i-1] + 0.01;
    flux[i] = 0.0;
    fluxerr[i] = 0.0;
  }

  (*mfunc)(energy, nbins, params, 1, flux, fluxerr, "");

}

int nbins_f = nbins;

void eval_model_f(f_model_ptr mfunc,
          float *params) {

  float energy[nbins_f];
  float flux[nbins_f];
  float fluxerr[nbins_f];
  int i;
  int sp = 1;

  energy[0] = 0.1;
  flux[0] = 0.0;
  fluxerr[0] = 0.0;
  for (i=1; i < nbins_f; i++) {
    energy[i] = energy[i-1] + 0.01;
    flux[i] = 0.0;
    fluxerr[i] = 0.0;
  }

  (*mfunc)(energy, &nbins_f, params, &sp, flux, fluxerr);

}


const int gnei_npars = 5;
double gnei_params[gnei_npars] = { 1, 1, 1e11, 1, 0 };

const int nei_npars = 4;
double nei_params[nei_npars] = { 1, 1, 1e11, 0 };

const int rnei_npars = 5;
double rnei_params[rnei_npars] = { 0.5, 1, 1, 1e11, 0 };

const int vgnei_npars = 17;
double vgnei_params[vgnei_npars] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1e11, 1, 0 };

const int vnei_npars = 16;
double vnei_params[vnei_npars] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1e11, 0 };

const int vrnei_npars = 17;
double vrnei_params[vrnei_npars] = { 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1e11, 0 };

const int vvgnei_npars = 34;
double vvgnei_params[vvgnei_npars] = { 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                       1e11, 1, 0 };

const int vvnei_npars = 33;
double vvnei_params[vvnei_npars] = { 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
               1e11, 0 };

const int vvrnei_npars = 34;
double vvrnei_params[vvrnei_npars] = { 0.5, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
               1e11, 0 };



const int zvarabs_npars = 19;
float zvarabs_params[zvarabs_npars] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1, 0 };

int main(int argc ,char **argv) {

  char version[100];

  FNINIT();
  xs_getVersion(version, 99);
  std::cout << "X-Spec: " << version << std::endl;

  std::cout << "** abundances   : " << FGSOLR() << std::endl;
  std::cout << "** cross-section: " << FGXSCT() << std::endl;

  FPCHAT(0);

  csmph0( 70.0 );
  csmpq0( 0.0 );
  csmpl0( 0.73 );

  // follow the order used in my python test scripts, in case the
  // behaviour I see there is due to an ordering issue.

  eval_model(C_gnei, gnei_params);
  eval_model(C_nei, nei_params);
  eval_model(C_rnei, rnei_params);
  eval_model(C_vgnei, vgnei_params);
  eval_model(C_vnei, vnei_params);
  eval_model(C_vrnei, vrnei_params);
  eval_model(C_vvgnei, vvgnei_params);
  eval_model(C_vvnei, vvnei_params);
  eval_model(C_vvrnei, vvrnei_params);

  // have seen some problems with this
  // eval_model_f(xszvab_, zvarabs_params);

  return 0;
}

