MATLAB="/Applications/MATLAB_R2018b.app"
Arch=maci64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/Users/nikovertovec/Library/Application Support/MathWorks/MATLAB/R2018b"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for find_rocket_c" > find_rocket_c_mex.mki
echo "CC=$CC" >> find_rocket_c_mex.mki
echo "CFLAGS=$CFLAGS" >> find_rocket_c_mex.mki
echo "CLIBS=$CLIBS" >> find_rocket_c_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> find_rocket_c_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> find_rocket_c_mex.mki
echo "CXX=$CXX" >> find_rocket_c_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> find_rocket_c_mex.mki
echo "CXXLIBS=$CXXLIBS" >> find_rocket_c_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> find_rocket_c_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> find_rocket_c_mex.mki
echo "LDFLAGS=$LDFLAGS" >> find_rocket_c_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> find_rocket_c_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> find_rocket_c_mex.mki
echo "Arch=$Arch" >> find_rocket_c_mex.mki
echo "LD=$LDXX" >> find_rocket_c_mex.mki
echo OMPFLAGS= >> find_rocket_c_mex.mki
echo OMPLINKFLAGS= >> find_rocket_c_mex.mki
echo "EMC_COMPILER=clang" >> find_rocket_c_mex.mki
echo "EMC_CONFIG=optim" >> find_rocket_c_mex.mki
"/Applications/MATLAB_R2018b.app/bin/maci64/gmake" -j 1 -B -f find_rocket_c_mex.mk
