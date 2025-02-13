#!/usr/bin/env bash

# NOTICE: Keep synchronized with test_ncrystal.bat

set -eux

${PYTHON} -m pip list
${PYTHON} -m pip check
${PYTHON} -m pip show ncrystal-python
${PYTHON} -m pip show ncrystal-core
${PYTHON} -m pip show ncrystal

#fixme Replicate to .bat:
#fixme add --fail-if-devel to next line once out of development:
${PYTHON} ./src/devel/bin/ncdevtool verifytag -t "${PKG_VERSION}" -p 'X.Y.Z' --file-verify=VERSION
${PYTHON} ./src/devel/bin/ncdevtool check -n fixme

ncrystal-config --help
ncrystal-config -s
test -f $(ncrystal-config --show libpath)
test -f $(ncrystal-config --show shlibpath)
test -d $(ncrystal-config --show includedir)
test -f $(ncrystal-config --show includedir)/NCrystal/NCrystal.hh
test -f $(ncrystal-config --show includedir)/NCrystal/ncapi.h

${PYTHON} -c 'import NCrystal; NCrystal.test()'
${PYTHON} -mNCrystal.test cmdline
nctool --help
ncrystal_cif2ncmat --help
ncrystal_endf2ncmat --help
ncrystal_hfg2ncmat --help
ncrystal_mcstasunion --help
ncrystal_ncmat2cpp --help
ncrystal_ncmat2hkl --help
ncrystal_vdos2ncmat --help
ncrystal_verifyatompos --help
nctool --test
cmake --find-package -DNAME=NCrystal -DCOMPILER_ID=GNU -DLANGUAGE=CXX -DMODE=EXIST

test -f ./src/ncrystal_pypluginmgr/pyproject.toml
test -f ./src/examples/plugin/pyproject.toml

${PYTHON} -m pip install ./src/ncrystal_pypluginmgr -vv --no-deps --no-build-isolation
${PYTHON} -m pip check
${PYTHON} -m pip install ./src/examples/plugin -vv --no-deps --no-build-isolation
${PYTHON} -m pip check

export NCRYSTAL_PLUGIN_RUNTESTS=1
export NCRYSTAL_REQUIRED_PLUGINS=DummyPlugin
nctool --plugins
unset NCRYSTAL_PLUGIN_RUNTESTS
unset NCRYSTAL_REQUIRED_PLUGINS
nctool -d plugins::DummyPlugin/somefile.ncmat

${PYTHON} -m pip install ./src/examples/plugin_dataonly -vv --no-deps --no-build-isolation
${PYTHON} -m pip check
nctool -d plugins::DummyDataPlugin/dummy.ncmat
