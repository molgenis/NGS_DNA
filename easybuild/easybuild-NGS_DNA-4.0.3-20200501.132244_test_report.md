#### Test result
Successfully built /home/umcg-gvdvries/easybuild-easyconfigs/easybuild/easyconfigs/n/NGS_DNA/NGS_DNA-4.0.3-foss-2018b.eb

#### Overview of tested easyconfigs (in order)
 * **SUCCESS** _NGS_DNA-4.0.3-foss-2018b.eb_ 

#### Time info
 * start: Fri, 01 May 2020 13:22:19 +0000 (UTC)
 * end: Fri, 01 May 2020 13:22:44 +0000 (UTC)

#### EasyBuild info
 * easybuild-framework version: 3.9.3
 * easybuild-easyblocks version: 3.9.3
 * command line:
```
eb -r ../../ NGS_DNA-4.0.3-foss-2018b.eb
```
 * full configuration (includes defaults):
```
--allow-loaded-modules='EasyBuild'
--buildpath='/apps/.tmp/easybuild/builds/'
--check-ebroot-env-vars='warn'
--cleanup-builddir
--cleanup-easyconfigs
--cleanup-tmpdir
--color='auto'
--container-type='singularity'
--containerpath='/home/umcg-gvdvries/.local/easybuild/containers'
--default-opt-level='defaultopt'
--detect-loaded-modules='warn'
--disable-add-dummy-to-minimal-toolchains
--disable-allow-modules-tool-mismatch
--disable-allow-use-as-root-and-accept-consequences
--disable-avail-cfgfile-constants
--disable-avail-easyconfig-constants
--disable-avail-easyconfig-licenses
--disable-avail-easyconfig-params
--disable-avail-easyconfig-templates
--disable-avail-hooks
--disable-avail-module-naming-schemes
--disable-avail-modules-tools
--disable-avail-repositories
--disable-check-conflicts
--disable-check-contrib
--disable-check-github
--disable-check-style
--disable-consider-archived-easyconfigs
--disable-container-build-image
--disable-containerize
--disable-debug
--disable-debug-lmod
--disable-devel
--disable-dry-run
--disable-dry-run-short
--disable-dump-autopep8
--disable-dump-env-script
--disable-experimental
--disable-extended-dry-run
--disable-fetch
--disable-fixed-installdir-naming-scheme
--disable-force
--disable-group-writable-installdir
--disable-hidden
--disable-ignore-checksums
--disable-ignore-osdeps
--disable-info
--disable-install-github-token
--disable-install-latest-eb-release
--disable-job
--disable-last-log
--disable-list-toolchains
--disable-logtostdout
--disable-missing-modules
--disable-module-depends-on
--disable-module-only
--disable-new-pr
--disable-package
--disable-pretend
--disable-preview-pr
--disable-quiet
--disable-read-only-installdir
--disable-rebuild
--disable-recursive-module-unload
--disable-regtest
--disable-rpath
--disable-sequential
--disable-set-default-module
--disable-show-config
--disable-show-default-configfiles
--disable-show-default-moduleclasses
--disable-show-full-config
--disable-show-system-info
--disable-skip
--disable-skip-test-cases
--disable-sticky-bit
--disable-terse
--disable-trace
--disable-update-modules-tool-cache
--disable-upload-test-report
--disable-use-existing-modules
--enforce-checksums
--extended-dry-run-ignore-errors
--ignore-dirs='.git,.svn'
--include-easyblocks=''
--include-module-naming-schemes=''
--include-toolchains=''
--installpath='/apps'
--job-backend='GC3Pie'
--job-max-jobs='0'
--job-max-walltime='24'
--job-output-dir='/home/umcg-gvdvries/easybuild-easyconfigs/easybuild/easyconfigs/n/NGS_DNA'
--job-polling-interval='30.0'
--lib64-fallback-sanity-check
--logfile-format='easybuild,easybuild-%(name)s-%(version)s-%(date)s.%(time)s.log'
--map-toolchains
--max-fail-ratio-adjust-permissions='0.5'
--minimal-toolchains
--module-naming-scheme='EasyBuildMNS'
--module-syntax='Lua'
--moduleclasses='base,astro,bio,cae,chem,compiler,data,debugger,devel,geo,ide,lang,lib,math,mpi,numlib,perf,quantum,phys,system,toolchain,tools,vis'
--modules-tool-version-check
--modules-tool='Lmod'
--mpi-tests
--output-format='txt'
--package-naming-scheme='EasyBuildPNS'
--package-release='1'
--package-tool-options=''
--package-tool='fpm'
--package-type='rpm'
--packagepath='/home/umcg-gvdvries/.local/easybuild/packages'
--pr-target-account='easybuilders'
--pr-target-branch='develop'
--pr-target-repo='easybuild-easyconfigs'
--pre-create-installdir
--repository='FileRepository'
--repositorypath='/home/umcg-gvdvries/.local/easybuild/ebfiles_repo'
--robot-paths='/home/umcg-gvdvries/easybuild-easyconfigs/easybuild/easyconfigs:'
--robot='/home/umcg-gvdvries/easybuild-easyconfigs/easybuild/easyconfigs:/apps/software/EasyBuild/3.9.3/lib/python2.7/site-packages/easybuild_easyconfigs-3.9.3-py2.7.egg/easybuild/easyconfigs'
--set-gid-bit
--sourcepath='/apps/sources/'
--strict='warn'
--subdir-modules='modules'
--subdir-software='software'
--suffix-modules-path='all'
--umask='002'
--use-ccache='False'
--use-f90cache='False'
--verify-easyconfig-filenames
````

#### System info
 * _core count:_ 4
 * _cpu model:_ Intel Core Processor (Broadwell, IBRS)
 * _cpu speed:_ 2399.996
 * _cpu vendor:_ Intel
 * _gcc version:_ Using built-in specs.; COLLECT_GCC=gcc; COLLECT_LTO_WRAPPER=/apps/software/GCCcore/7.3.0/libexec/gcc/x86_64-pc-linux-gnu/7.3.0/lto-wrapper; Target: x86_64-pc-linux-gnu; Configured with: ../configure --enable-languages=c,c++,fortran --enable-lto --enable-checking=release --disable-multilib --enable-shared=yes --enable-static=yes --enable-threads=posix --enable-gold=default --enable-plugins --enable-ld --with-plugin-ld=ld.gold --prefix=/apps/software/GCCcore/7.3.0 --with-local-prefix=/apps/software/GCCcore/7.3.0 --enable-bootstrap --with-isl=/apps/.tmp/easybuild/builds/GCCcore/7.3.0/dummy-/gcc-7.3.0/stage2_stuff; Thread model: posix; gcc version 7.3.0 (GCC) ; 
 * _glibc version:_ 2.17
 * _hostname:_ sugarsnax
 * _os name:_ centos linux
 * _os type:_ Linux
 * _os version:_ 7.7.1908
 * _platform name:_ x86_64-unknown-linux
 * _python version:_ 2.7.16 (default, Sep  4 2019, 11:54:22) ; [GCC 7.3.0]
 * _system gcc path:_ /apps/software/GCCcore/7.3.0/bin/gcc
 * _system python path:_ /apps/software/Python/2.7.16-GCCcore-7.3.0-bare/bin/python
 * _total memory:_ 3789

#### List of loaded modules
 * GCCcore/7.3.0
 * binutils/2.30-GCCcore-7.3.0
 * GCC/7.3.0-2.30
 * zlib/1.2.11-GCCcore-7.3.0
 * numactl/2.0.11-GCCcore-7.3.0
 * XZ/5.2.4-GCCcore-7.3.0
 * libxml2/2.9.8-GCCcore-7.3.0
 * libpciaccess/0.14-GCCcore-7.3.0
 * hwloc/1.11.10-GCCcore-7.3.0
 * OpenMPI/3.1.1-GCC-7.3.0-2.30
 * OpenBLAS/0.3.1-GCC-7.3.0-2.30
 * gompi/2018b
 * FFTW/3.3.8-gompi-2018b
 * ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1
 * foss/2018b
 * libreadline/8.0-GCCcore-7.3.0
 * Tcl/8.6.9-GCCcore-7.3.0
 * SQLite/3.29.0-GCCcore-7.3.0
 * GMP/6.1.2-GCCcore-7.3.0
 * libffi/3.2.1-GCCcore-7.3.0
 * Python/2.7.16-GCCcore-7.3.0-bare
 * PythonPlus/2.7.16-foss-2018b-v20.02.1
 * SAMtools/1.9-foss-2018b
 * Perl/5.30.0-GCCcore-7.3.0-bare
 * expat/2.2.7-GCCcore-7.3.0
 * libpng/1.6.37-GCCcore-7.3.0
 * freetype/2.10.1-GCCcore-7.3.0
 * ncurses/6.1-GCCcore-7.3.0
 * util-linux/2.34-GCCcore-7.3.0
 * fontconfig/2.13.1-GCCcore-7.3.0
 * NASM/2.13.03-GCCcore-7.3.0
 * libjpeg-turbo/2.0.2-GCCcore-7.3.0
 * libgd/2.2.5-GCCcore-7.3.0-lor
 * LibTIFF/4.0.10-GCCcore-7.3.0
 * PCRE/8.43-GCCcore-7.3.0
 * AdoptOpenJDK/11.0.4_11-hotspot
 * Java/11-LTS
 * pixman/0.38.4-GCCcore-7.3.0
 * gettext/0.20.1-GCCcore-7.3.0
 * GLib/2.61.1-GCCcore-7.3.0
 * cairo/1.16.0-GCCcore-7.3.0
 * HarfBuzz/2.5.3-GCCcore-7.3.0
 * FriBidi/1.0.5-GCCcore-7.3.0
 * Pango/1.43.0-GCCcore-7.3.0
 * R/3.6.1-foss-2018b-bare
 * PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1
 * XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0
 * Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0
 * bzip2/1.0.6-GCCcore-7.3.0
 * cURL/7.63.0-GCCcore-7.3.0
 * HTSlib/1.9-GCCcore-7.3.0
 * VEP/92.0-foss-2018b-Perl-5.30.0
 * CADD/v1.4-foss-2018b
 * BioPerl/1.7.2-foss-2018b-Perl-5.30.0
 * EasyBuild/3.9.3

#### Environment
```
ACLOCAL_PATH = /apps/software/cURL/7.63.0-GCCcore-7.3.0/share/aclocal:/apps/software/GLib/2.61.1-GCCcore-7.3.0/share/aclocal:/apps/software/gettext/0.20.1-GCCcore-7.3.0/share/aclocal:/apps/software/freetype/2.10.1-GCCcore-7.3.0/share/aclocal:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/share/aclocal
BASH_FUNC_ml() = () {  eval $($LMOD_DIR/ml_cmd "$@")
}
BASH_FUNC_module() = () {  eval $($LMOD_CMD bash "$@") && eval $(${LMOD_SETTARG_CMD:-:} -s sh)
}
BENDER = 172.23.34.246
BOXY = 172.23.34.237
CALCULON = 172.23.34.247
CPATH = /apps/software/HTSlib/1.9-GCCcore-7.3.0/include:/apps/software/cURL/7.63.0-GCCcore-7.3.0/include:/apps/software/bzip2/1.0.6-GCCcore-7.3.0/include:/apps/software/Pango/1.43.0-GCCcore-7.3.0/include:/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/include:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/include:/apps/software/cairo/1.16.0-GCCcore-7.3.0/include:/apps/software/GLib/2.61.1-GCCcore-7.3.0/include:/apps/software/gettext/0.20.1-GCCcore-7.3.0/include:/apps/software/pixman/0.38.4-GCCcore-7.3.0/include:/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/include:/apps/software/PCRE/8.43-GCCcore-7.3.0/include:/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/include:/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/include:/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/include:/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/include:/apps/software/util-linux/2.34-GCCcore-7.3.0/include:/apps/software/ncurses/6.1-GCCcore-7.3.0/include:/apps/software/freetype/2.10.1-GCCcore-7.3.0/include/freetype2:/apps/software/libpng/1.6.37-GCCcore-7.3.0/include:/apps/software/expat/2.2.7-GCCcore-7.3.0/include:/apps/software/SAMtools/1.9-foss-2018b/include:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages/numpy-1.14.2-py2.7-linux-x86_64.egg/numpy/core/include:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/include:/apps/software/libffi/3.2.1-GCCcore-7.3.0/include:/apps/software/GMP/6.1.2-GCCcore-7.3.0/include:/apps/software/SQLite/3.29.0-GCCcore-7.3.0/include:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/include:/apps/software/libreadline/8.0-GCCcore-7.3.0/include:/apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/include:/apps/software/FFTW/3.3.8-gompi-2018b/include:/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/include:/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/include:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/include:/apps/software/libpciaccess/0.14-GCCcore-7.3.0/include:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/include/libxml2:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/include:/apps/software/XZ/5.2.4-GCCcore-7.3.0/include:/apps/software/numactl/2.0.11-GCCcore-7.3.0/include:/apps/software/zlib/1.2.11-GCCcore-7.3.0/include:/apps/software/binutils/2.30-GCCcore-7.3.0/include:/apps/software/GCCcore/7.3.0/include
CURL_INCLUDES = /apps/software/cURL/7.63.0-GCCcore-7.3.0/include
EASYBUILD_BUILDPATH = /apps/.tmp/easybuild/builds/
EASYBUILD_ENFORCE_CHECKSUMS = True
EASYBUILD_INSTALLPATH = /apps
EASYBUILD_MINIMAL_TOOLCHAINS = True
EASYBUILD_MODULES_TOOL = Lmod
EASYBUILD_MODULE_SYNTAX = Lua
EASYBUILD_SET_GID_BIT = 1
EASYBUILD_SOURCEPATH = /apps/sources/
EASYBUILD_UMASK = 002
EASYBUILD_VERIFY_EASYCONFIG_FILENAMES = True
EBDEVELADOPTOPENJDK = /apps/software/AdoptOpenJDK/11.0.4_11-hotspot/easybuild/AdoptOpenJDK-11.0.4_11-hotspot-easybuild-devel
EBDEVELBINUTILS = /apps/software/binutils/2.30-GCCcore-7.3.0/easybuild/binutils-2.30-GCCcore-7.3.0-easybuild-devel
EBDEVELBIOMINDBMINHTS = /apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/easybuild/Bio-DB-HTS-2.11-foss-2018b-Perl-5.30.0-easybuild-devel
EBDEVELBIOPERL = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/easybuild/BioPerl-1.7.2-foss-2018b-Perl-5.30.0-easybuild-devel
EBDEVELBZIP2 = /apps/software/bzip2/1.0.6-GCCcore-7.3.0/easybuild/bzip2-1.0.6-GCCcore-7.3.0-easybuild-devel
EBDEVELCADD = /apps/software/CADD/v1.4-foss-2018b/easybuild/CADD-v1.4-foss-2018b-easybuild-devel
EBDEVELCAIRO = /apps/software/cairo/1.16.0-GCCcore-7.3.0/easybuild/cairo-1.16.0-GCCcore-7.3.0-easybuild-devel
EBDEVELCURL = /apps/software/cURL/7.63.0-GCCcore-7.3.0/easybuild/cURL-7.63.0-GCCcore-7.3.0-easybuild-devel
EBDEVELEASYBUILD = /apps/software/EasyBuild/3.9.3/easybuild/EasyBuild-3.9.3-easybuild-devel
EBDEVELEXPAT = /apps/software/expat/2.2.7-GCCcore-7.3.0/easybuild/expat-2.2.7-GCCcore-7.3.0-easybuild-devel
EBDEVELFFTW = /apps/software/FFTW/3.3.8-gompi-2018b/easybuild/FFTW-3.3.8-gompi-2018b-easybuild-devel
EBDEVELFONTCONFIG = /apps/software/fontconfig/2.13.1-GCCcore-7.3.0/easybuild/fontconfig-2.13.1-GCCcore-7.3.0-easybuild-devel
EBDEVELFOSS = /apps/software/foss/2018b/easybuild/foss-2018b-easybuild-devel
EBDEVELFREETYPE = /apps/software/freetype/2.10.1-GCCcore-7.3.0/easybuild/freetype-2.10.1-GCCcore-7.3.0-easybuild-devel
EBDEVELFRIBIDI = /apps/software/FriBidi/1.0.5-GCCcore-7.3.0/easybuild/FriBidi-1.0.5-GCCcore-7.3.0-easybuild-devel
EBDEVELGCC = /apps/software/GCC/7.3.0-2.30/easybuild/GCC-7.3.0-2.30-easybuild-devel
EBDEVELGCCCORE = /apps/software/GCCcore/7.3.0/easybuild/GCCcore-7.3.0-easybuild-devel
EBDEVELGETTEXT = /apps/software/gettext/0.20.1-GCCcore-7.3.0/easybuild/gettext-0.20.1-GCCcore-7.3.0-easybuild-devel
EBDEVELGLIB = /apps/software/GLib/2.61.1-GCCcore-7.3.0/easybuild/GLib-2.61.1-GCCcore-7.3.0-easybuild-devel
EBDEVELGMP = /apps/software/GMP/6.1.2-GCCcore-7.3.0/easybuild/GMP-6.1.2-GCCcore-7.3.0-easybuild-devel
EBDEVELGOMPI = /apps/software/gompi/2018b/easybuild/gompi-2018b-easybuild-devel
EBDEVELHARFBUZZ = /apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/easybuild/HarfBuzz-2.5.3-GCCcore-7.3.0-easybuild-devel
EBDEVELHTSLIB = /apps/software/HTSlib/1.9-GCCcore-7.3.0/easybuild/HTSlib-1.9-GCCcore-7.3.0-easybuild-devel
EBDEVELHWLOC = /apps/software/hwloc/1.11.10-GCCcore-7.3.0/easybuild/hwloc-1.11.10-GCCcore-7.3.0-easybuild-devel
EBDEVELJAVA = /apps/software/Java/11-LTS/easybuild/Java-11-LTS-easybuild-devel
EBDEVELLIBFFI = /apps/software/libffi/3.2.1-GCCcore-7.3.0/easybuild/libffi-3.2.1-GCCcore-7.3.0-easybuild-devel
EBDEVELLIBGD = /apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/easybuild/libgd-2.2.5-GCCcore-7.3.0-lor-easybuild-devel
EBDEVELLIBJPEGMINTURBO = /apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/easybuild/libjpeg-turbo-2.0.2-GCCcore-7.3.0-easybuild-devel
EBDEVELLIBPCIACCESS = /apps/software/libpciaccess/0.14-GCCcore-7.3.0/easybuild/libpciaccess-0.14-GCCcore-7.3.0-easybuild-devel
EBDEVELLIBPNG = /apps/software/libpng/1.6.37-GCCcore-7.3.0/easybuild/libpng-1.6.37-GCCcore-7.3.0-easybuild-devel
EBDEVELLIBREADLINE = /apps/software/libreadline/8.0-GCCcore-7.3.0/easybuild/libreadline-8.0-GCCcore-7.3.0-easybuild-devel
EBDEVELLIBTIFF = /apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/easybuild/LibTIFF-4.0.10-GCCcore-7.3.0-easybuild-devel
EBDEVELLIBXML2 = /apps/software/libxml2/2.9.8-GCCcore-7.3.0/easybuild/libxml2-2.9.8-GCCcore-7.3.0-easybuild-devel
EBDEVELNASM = /apps/software/NASM/2.13.03-GCCcore-7.3.0/easybuild/NASM-2.13.03-GCCcore-7.3.0-easybuild-devel
EBDEVELNCURSES = /apps/software/ncurses/6.1-GCCcore-7.3.0/easybuild/ncurses-6.1-GCCcore-7.3.0-easybuild-devel
EBDEVELNUMACTL = /apps/software/numactl/2.0.11-GCCcore-7.3.0/easybuild/numactl-2.0.11-GCCcore-7.3.0-easybuild-devel
EBDEVELOPENBLAS = /apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/easybuild/OpenBLAS-0.3.1-GCC-7.3.0-2.30-easybuild-devel
EBDEVELOPENMPI = /apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/easybuild/OpenMPI-3.1.1-GCC-7.3.0-2.30-easybuild-devel
EBDEVELPANGO = /apps/software/Pango/1.43.0-GCCcore-7.3.0/easybuild/Pango-1.43.0-GCCcore-7.3.0-easybuild-devel
EBDEVELPCRE = /apps/software/PCRE/8.43-GCCcore-7.3.0/easybuild/PCRE-8.43-GCCcore-7.3.0-easybuild-devel
EBDEVELPERL = /apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/easybuild/Perl-5.30.0-GCCcore-7.3.0-bare-easybuild-devel
EBDEVELPERLPLUS = /apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/easybuild/PerlPlus-5.30.0-GCCcore-7.3.0-v19.08.1-easybuild-devel
EBDEVELPIXMAN = /apps/software/pixman/0.38.4-GCCcore-7.3.0/easybuild/pixman-0.38.4-GCCcore-7.3.0-easybuild-devel
EBDEVELPYTHON = /apps/software/Python/2.7.16-GCCcore-7.3.0-bare/easybuild/Python-2.7.16-GCCcore-7.3.0-bare-easybuild-devel
EBDEVELPYTHONPLUS = /apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/easybuild/PythonPlus-2.7.16-foss-2018b-v20.02.1-easybuild-devel
EBDEVELR = /apps/software/R/3.6.1-foss-2018b-bare/easybuild/R-3.6.1-foss-2018b-bare-easybuild-devel
EBDEVELSAMTOOLS = /apps/software/SAMtools/1.9-foss-2018b/easybuild/SAMtools-1.9-foss-2018b-easybuild-devel
EBDEVELSCALAPACK = /apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/easybuild/ScaLAPACK-2.0.2-gompi-2018b-OpenBLAS-0.3.1-easybuild-devel
EBDEVELSQLITE = /apps/software/SQLite/3.29.0-GCCcore-7.3.0/easybuild/SQLite-3.29.0-GCCcore-7.3.0-easybuild-devel
EBDEVELTCL = /apps/software/Tcl/8.6.9-GCCcore-7.3.0/easybuild/Tcl-8.6.9-GCCcore-7.3.0-easybuild-devel
EBDEVELUTILMINLINUX = /apps/software/util-linux/2.34-GCCcore-7.3.0/easybuild/util-linux-2.34-GCCcore-7.3.0-easybuild-devel
EBDEVELVEP = /apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/easybuild/VEP-92.0-foss-2018b-Perl-5.30.0-easybuild-devel
EBDEVELXMLMINLIBXML = /apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/easybuild/XML-LibXML-2.0132-GCCcore-7.3.0-Perl-5.30.0-easybuild-devel
EBDEVELXZ = /apps/software/XZ/5.2.4-GCCcore-7.3.0/easybuild/XZ-5.2.4-GCCcore-7.3.0-easybuild-devel
EBDEVELZLIB = /apps/software/zlib/1.2.11-GCCcore-7.3.0/easybuild/zlib-1.2.11-GCCcore-7.3.0-easybuild-devel
EBEXTSLISTPERLPLUS = strictures-2.000006,Dist::CheckConflicts-0.11,Package::Stash-0.38,Sub::Exporter::Progressive-0.001013,Test::Requires-0.10,Try::Tiny-0.30,Test::Fatal-0.014,Module::Build-0.4229,Module::Runtime-0.016,Module::Implementation-0.09,B::Hooks::EndOfScope-0.24,namespace::clean-0.27,Sub::Identify-0.14,namespace::autoclean-0.28,common::sense-3.74,boolean-0.46,aliased-0.34,YAML::Tiny-1.73,Text::Diff-1.45,Spiffy-0.46,Algorithm::Diff-1.1903,Test::Base-0.89,Test::YAML-1.07,Test::Deep-1.128,YAML-1.29,WWW::RobotRules-6.02,Test::RequiresInternet-0.05,Net::HTTP-6.19,HTTP::Negotiate-6.01,HTTP::Daemon-6.05,Test::Needs-0.002006,URI-1.76,LWP::MediaTypes-6.04,IO::HTML-1.001,HTTP::Headers::Util-6.18,HTTP::Cookies-6.04,HTML::Tagset-3.20,HTML::Entities-3.72,HTTP::Date-6.02,File::Listing-6.04,Encode::Locale-1.05,LWP::UserAgent-6.39,XML::Parser-2.44,Scalar::Util-1.51,Path::Tiny-0.108,XML::XPath-1.44,XML::Twig-3.52,XML::Tiny-2.07,XML::SAX::Exception-1.09,XML::SAX::Base-1.09,XML::NamespaceSupport-1.12,XML::SAX-1.02,XML::SAX::Expat-0.51,XML::Simple-2.25,XML::Filter::BufferText-1.01,XML::SAX::Writer-0.57,XML::RegExp-0.04,File::chdir-0.1010,File::Which-1.23,Term::Table-0.013,Sub::Info-0.002,Scope::Guard-0.21,Module::Pluggable::Object-5.2,Importer-0.025,Test2::Mock-0.000122,Test2::API-1.302164,FFI::CheckLib-0.25,ExtUtils::ParseXS-3.35,Capture::Tiny-0.48,Alien::Base-1.79,Alien::Libxml2-0.09,XML::LibXML-2.0201,XML::LibXML::Simple-0.99,XML::Parser::PerlSAX-0.08,XML::DOM-1.46,LWP-6.39,File::Slurp::Tiny-0.004,XML::Compile::SOAP11-3.24,XML::Compile::Cache-1.06,XML::Compile::Tester-0.91,Types::Serialiser-1.0,XML::Compile-1.63,MIME::Charset-1.012.2,Unicode::GCString-2019.001,Date::Parse-2.30,String::Print-0.93,Log::Report::Optional-1.06,Devel::GlobalDestruction-0.14,Log::Report-1.28,XML::Compile::WSDL11-3.07,XML::Compile::SOAP-3.24,XML::Bare-0.53,Want-0.29,Test::Warn-0.36,Test::More-1.302164,Sub::Uplevel-0.2800,Test::Exception-0.43,Test::Differences-0.67,Devel::StackTrace-2.04,Class::Data::Inheritable-0.08,Exception::Class-1.44,Test::Most-0.35,VCF-1.003,Unicode::LineBreak-2019.001,UNIVERSAL::moniker-0.08,Exporter::Tiny-1.002001,Type::Tiny-1.004004,Tree::DAG_Node-1.31,Time::Piece::MySQL-0.06,Tie::IxHash-1.23,Tie::Function-0.02,Sub::Defer-2.006003,Role::Tiny-2.000008,Class::Method::Modifiers-2.12,Moo-2.003004,Throwable-0.200013,Test::Warnings-0.026,Test::More::UTF8-0.05,Text::Template-1.56,Text::Aligner-0.13,Text::Table-1.133,Text::Soundex-3.05,Text::Iconv-1.7,Text::Glob-0.11,Text::Format-0.61,Text::CSV-2.00,Module::ScanDeps-1.27,File::Remove-1.58,inc::Module::Install-1.19,Test::utf8-1.01,Params::Util-1.07,Number::Compare-0.03,File::Find::Rule-0.34,File::Find::Rule::Perl-1.15,Test::Version-2.09,Data::Dump-1.23,Test::Trap-v0.3.4,Hook::LexWrap-0.26,Test::SubCalls-1.10,Test::Simple-1.302164,Test::Pod-1.52,Test::Output-1.031,Test::Object-0.08,Test::NoWarnings-1.04,SUPER-1.20190531,Test::MockModule-v0.170.0,Test::LeakTrace-0.16,Test::InDistDir-1.112071,Test::Fork-0.02,Test::File-1.443,Meta::Builder-0.004,Fennec::Lite-0.004,Exporter::Declare-0.114,Mock::Quick-1.111,Test::Exception::LessClever-0.009,Sub::Install-0.928,Data::OptList-0.110,Sub::Exporter-0.987,File::pushd-1.016,Test::CleanNamespaces-0.24,Config::Tiny-2.24,Class::Inspector-1.36,Test::ClassAPI-1.07,Log::Message-0.08,Log::Message::Simple-0.10,Term::UI-0.46,Term::ReadKey-2.38,Class::MethodMaker-2.24,Term::ProgressBar-2.22,Term::Encoding-0.03,CGI-4.44,AppConfig-1.71,Template::Toolkit-2.29,Template-2.29,Number::Format-1.75,Template::Plugin::Number::Format-1.06,Task::Weaken-1.06,Switch-2.17,Sub::Quote-2.006003,Sub::Name-0.21,Sub::Exporter::ForMethods-0.100052,String::Truncate-1.100602,String::RewritePrefix-0.007,JSON::MaybeXS-1.004000,String::Flogger-1.101245,Regexp::Common-2017060201,ExtUtils::InstallPaths-0.012,ExtUtils::Helpers-0.026,ExtUtils::Config-0.008,Module::Build::Tiny-0.039,Readonly-2.05,IO::Pty-1.12,IPC::Run-20180523.0,Statistics::R-0.34,Statistics::Normality-0.01,Statistics::Distributions-1.02,List::MoreUtils::XS-0.428,List::MoreUtils-0.428,Statistics::Descriptive-3.0702,Statistics::Basic-1.6611,OLE::Storage_Lite-0.19,IO::Scalar-2.111,Digest::Perl::MD5-1.9,Crypt::RC4-2.02,Spreadsheet::ParseExcel-0.65,MRO::Compat-0.13,Eval::Closure-0.14,Specio-0.43,Test::FailWarnings-0.008,Data::Section-0.200007,Software::License-0.103014,Shell-0.73,Set::Scalar-1.29,Data::Types-0.17,Set::IntSpan::Fast-1.15,Set::IntSpan-1.19,Set::Array-0.30,SVG-2.84,Math::Base::Convert-0.11,B::COW-0.001,Clone-0.43,SQL::Statement-1.412,Test::Without::Module-0.20,Clone::Choose-0.010,Hash::Merge-0.300,SQL::Abstract-1.86,String::Formatter-0.102084,Date::Format-2.30,String::Errf-0.008,MooseX::Role::Parameterized-1.11,Package::Stash::XS-0.29,Package::DeprecationManager-0.17,Module::Runtime::Conflicts-0.003,List::Util-1.51,Devel::OverloadInfo-0.005,Class::Load::XS-0.10,Class::Load-0.25,CPAN::Meta::Check-0.014,Moose-2.2011,Role::HasMessage-0.006,Software::License::Artistic_1_0-0.103014,Pod::Eventual::Simple-0.094001,Carp::Clan-6.07,MooseX::Types-0.50,Pod::Elemental-0.103004,IO::String-1.08,PPI-1.270,Sub::Exporter::GlobExporter-0.005,Log::Dispatch::Array-1.003,Log::Dispatch-2.68,Log::Dispatchouli-2.019,Class::Singleton-1.5,DateTime::TimeZone-2.36,File::Copy::Recursive-0.45,Class::Tiny-1.006,Test::File::ShareDir::Dist-1.001002,Test2::Require::Module-0.000122,Test2-1.302164,IPC::Run3-0.048,Test2::Plugin::NoWarnings-0.07,Params::ValidationCompiler-0.30,IPC::System::Simple-1.25,File::ShareDir::Install-0.13,File::ShareDir-1.116,DateTime::Locale-1.24,DateTime-1.51,PerlIO::utf8_strict-0.007,Mixin::Linewise::Readers-0.108,Config::INI::Reader-0.025,Config::MVP::Reader::INI-2.101463,StackTrace::Auto-0.200013,Role::Identifiable::HasIdent-0.007,MooseX::OneArgNew-0.005,Config::MVP-2.200011,Pod::Weaver-4.015,Pod::Plainer-1.04,File::Slurper-0.012,Pod::POM-2.01,Pod::LaTeX-0.61,Pod::Eventual-0.094001,Path::Class-0.37,Parse::RecDescent-1.967015,Type::Utils-1.004004,File::Slurp-9999.27,CPAN::DistnameInfo-0.12,MooseX::Types::Path::Class-0.09,Archive::Zip-1.64,Archive::Peek-0.35,Parse::CPAN::Packages-2.40,Module::Pluggable-5.2,Params::Validate-1.29,Package::Constants-0.06,PadWalker-2.3,Devel::Cycle-1.12,Test::Memory::Cycle-1.06,Font::TTF-1.06,PDF::API2-2.034,Object::Accessor-0.48,Net::SSLeay-1.88,Net::SNMP-v6.0.1,Mozilla::CA-20180117,IO::Socket::SSL-2.066,Net::SMTP::SSL-1.04,File::Copy::Recursive::Reduced-0.006,Devel::CheckCompiler-0.07,Cwd::Guard-0.05,Module::Build::XSUtil-0.19,Mouse-v2.5.6,MooseX::Types::Perl-0.101343,MooseX::SetOnce-0.200002,MooseX::Role::WithOverloading-0.17,MooseX::LazyRequire-0.11,Getopt::Long::Descriptive-0.104,MooseX::Getopt-0.74,Module::Install-1.19,Mixin::Linewise-0.108,Math::VecStat-0.08,Math::Round-0.07,Math::CDF-0.1,Math::Bezier-0.01,MailTools-2.21,MIME::Types-2.17,Email::Date::Format-1.005,MIME::Lite-3.030,Log::Log4perl-1.49,Log::Handler-0.88,List::UtilsBy-0.11,List::SomeUtils-0.56,List::AllUtils-0.15,Lingua::EN::PluralToSingular-0.21,LWP::Protocol::https-6.07,JSON-4.02,Iterator::Simple-0.07,Import::Into-1.002005,DBIx::ContextualFetch-1.03,DBI-1.642,Ima::DBI-0.35,IO::Tty-1.12,HTTP::Headers-6.18,HTTP::Message-6.18,HTTP::Request-6.18,HTML::Tree-5.07,HTML::Template-2.97,HTML::Parser-3.72,HTML::TokeParser-3.72,HTML::Form-6.04,HTML::Entities::Interpolate-1.10,XML::Writer-0.625,Parse::Yapp::Driver-1.21,Graph-0.9704,Graph::ReadWrite-2.09,Error-0.17027,Git-0.42,GD-2.71,File::Next-1.16,File::HomeDir-1.004,File::Grep-0.02,File::CheckTree-4.42,Expect-1.35,Excel::Writer::XLSX-1.00,Devel::FindPerl-0.015,Module::Path-0.19,Perl::PrereqScanner-1.023,PPI::Document-1.270,HTTP::Request::Common-6.18,CPAN::Uploader-0.103013,IO::TieCombine-1.005,App::Cmd::Command::version-0.331,Dist::Zilla-6.012,Digest::SHA1-2.13,Digest::MD5::File-0.08,Digest::HMAC-1.03,Data::Compare-1.25,Devel::CheckOS-1.81,Mock::Config-0.03,IO::CaptureOutput-1.1104,Devel::CheckLib-1.13,DateTime::Tiny-1.07,Date::Handler-1.2,Data::UUID-1.224,Data::Stag-0.14,Data::Section::Simple-0.07,Data::Dumper::Concise-2.023,DBIx::Simple-1.37,Types::Standard-1.004004,Ref::Util-0.204,Class::XSAccessor-1.19,Hash::Objectify-0.008,Const::Fast-0.014,Const::Exporter-v0.4.1,Text::Table::Manifold-1.01,DBIx::Admin::DSNManager-2.01,DBIx::Admin::CreateTable-2.10,DBIx::Admin::TableInfo-3.03,DBD::mysql-4.050,DBD::SQLite-1.62,AnyData-0.12,DBD::AnyData-0.110,Curses-1.36,Crypt::Rijndael-1.14,Crypt::DES-2.07,Config::INI-0.025,Config::General-2.63,Class::Trigger-0.14,Class::ISA-0.36,Class::Accessor-0.51,Class::DBI-v3.0.17,Class::DBI::SQLite-0.11,Canary::Stability-2013,CPANPLUS-0.9178,CPAN::FindDependencies-2.48,Bundle::BioPerl-2.1.9,B::Lint-1.20,Digest::HMAC_MD5-1.03,Authen::SASL-2.16,Array::Utils-0.5,Archive::Extract-0.80,App::Cmd-0.331,AnyEvent-7.16,Algorithm::Dependency-1.111
EBEXTSLISTPYTHONPLUS = six-1.10.0,pytz-2017.2,setuptools-40.6.2,dateutil-2.6.1,pysam-0.11.2.1,pyvcf-0.6.8,numpy-1.14.2,scipy-1.0.1,scikit-learn-0.19.1,pandas-0.20.3,virtualenv-15.1.0
EBEXTSLISTR = b-a,c-o,d-a,g-r,g-r,g-r,m-e,p-a,s-p,s-t,s-t,t-o,u-t
EBROOTADOPTOPENJDK = /apps/software/AdoptOpenJDK/11.0.4_11-hotspot
EBROOTBINUTILS = /apps/software/binutils/2.30-GCCcore-7.3.0
EBROOTBIOMINDBMINHTS = /apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0
EBROOTBIOPERL = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0
EBROOTBZIP2 = /apps/software/bzip2/1.0.6-GCCcore-7.3.0
EBROOTCADD = /apps/software/CADD/v1.4-foss-2018b
EBROOTCAIRO = /apps/software/cairo/1.16.0-GCCcore-7.3.0
EBROOTCURL = /apps/software/cURL/7.63.0-GCCcore-7.3.0
EBROOTEASYBUILD = /apps/software/EasyBuild/3.9.3
EBROOTEXPAT = /apps/software/expat/2.2.7-GCCcore-7.3.0
EBROOTFFTW = /apps/software/FFTW/3.3.8-gompi-2018b
EBROOTFONTCONFIG = /apps/software/fontconfig/2.13.1-GCCcore-7.3.0
EBROOTFOSS = /apps/software/foss/2018b
EBROOTFREETYPE = /apps/software/freetype/2.10.1-GCCcore-7.3.0
EBROOTFRIBIDI = /apps/software/FriBidi/1.0.5-GCCcore-7.3.0
EBROOTGCC = /apps/software/GCCcore/7.3.0
EBROOTGCCCORE = /apps/software/GCCcore/7.3.0
EBROOTGETTEXT = /apps/software/gettext/0.20.1-GCCcore-7.3.0
EBROOTGLIB = /apps/software/GLib/2.61.1-GCCcore-7.3.0
EBROOTGMP = /apps/software/GMP/6.1.2-GCCcore-7.3.0
EBROOTGOMPI = /apps/software/gompi/2018b
EBROOTHARFBUZZ = /apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0
EBROOTHTSLIB = /apps/software/HTSlib/1.9-GCCcore-7.3.0
EBROOTHWLOC = /apps/software/hwloc/1.11.10-GCCcore-7.3.0
EBROOTJAVA = /apps/software/Java/11-LTS
EBROOTLIBFFI = /apps/software/libffi/3.2.1-GCCcore-7.3.0
EBROOTLIBGD = /apps/software/libgd/2.2.5-GCCcore-7.3.0-lor
EBROOTLIBJPEGMINTURBO = /apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0
EBROOTLIBPCIACCESS = /apps/software/libpciaccess/0.14-GCCcore-7.3.0
EBROOTLIBPNG = /apps/software/libpng/1.6.37-GCCcore-7.3.0
EBROOTLIBREADLINE = /apps/software/libreadline/8.0-GCCcore-7.3.0
EBROOTLIBTIFF = /apps/software/LibTIFF/4.0.10-GCCcore-7.3.0
EBROOTLIBXML2 = /apps/software/libxml2/2.9.8-GCCcore-7.3.0
EBROOTNASM = /apps/software/NASM/2.13.03-GCCcore-7.3.0
EBROOTNCURSES = /apps/software/ncurses/6.1-GCCcore-7.3.0
EBROOTNUMACTL = /apps/software/numactl/2.0.11-GCCcore-7.3.0
EBROOTOPENBLAS = /apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30
EBROOTOPENMPI = /apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30
EBROOTPANGO = /apps/software/Pango/1.43.0-GCCcore-7.3.0
EBROOTPCRE = /apps/software/PCRE/8.43-GCCcore-7.3.0
EBROOTPERL = /apps/software/Perl/5.30.0-GCCcore-7.3.0-bare
EBROOTPERLPLUS = /apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1
EBROOTPIXMAN = /apps/software/pixman/0.38.4-GCCcore-7.3.0
EBROOTPYTHON = /apps/software/Python/2.7.16-GCCcore-7.3.0-bare
EBROOTPYTHONPLUS = /apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1
EBROOTR = /apps/software/R/3.6.1-foss-2018b-bare
EBROOTSAMTOOLS = /apps/software/SAMtools/1.9-foss-2018b
EBROOTSCALAPACK = /apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1
EBROOTSQLITE = /apps/software/SQLite/3.29.0-GCCcore-7.3.0
EBROOTTCL = /apps/software/Tcl/8.6.9-GCCcore-7.3.0
EBROOTUTILMINLINUX = /apps/software/util-linux/2.34-GCCcore-7.3.0
EBROOTVEP = /apps/software/VEP/92.0-foss-2018b-Perl-5.30.0
EBROOTXMLMINLIBXML = /apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0
EBROOTXZ = /apps/software/XZ/5.2.4-GCCcore-7.3.0
EBROOTZLIB = /apps/software/zlib/1.2.11-GCCcore-7.3.0
EBVERSIONADOPTOPENJDK = 11.0.4_11
EBVERSIONBINUTILS = 2.30
EBVERSIONBIOMINDBMINHTS = 2.11
EBVERSIONBIOPERL = 1.7.2
EBVERSIONBZIP2 = 1.0.6
EBVERSIONCADD = v1.4
EBVERSIONCAIRO = 1.16.0
EBVERSIONCURL = 7.63.0
EBVERSIONEASYBUILD = 3.9.3
EBVERSIONEXPAT = 2.2.7
EBVERSIONFFTW = 3.3.8
EBVERSIONFONTCONFIG = 2.13.1
EBVERSIONFOSS = 2018b
EBVERSIONFREETYPE = 2.10.1
EBVERSIONFRIBIDI = 1.0.5
EBVERSIONGCC = 7.3.0
EBVERSIONGCCCORE = 7.3.0
EBVERSIONGETTEXT = 0.20.1
EBVERSIONGLIB = 2.61.1
EBVERSIONGMP = 6.1.2
EBVERSIONGOMPI = 2018b
EBVERSIONHARFBUZZ = 2.5.3
EBVERSIONHTSLIB = 1.9
EBVERSIONHWLOC = 1.11.10
EBVERSIONJAVA = 11
EBVERSIONLIBFFI = 3.2.1
EBVERSIONLIBGD = 2.2.5
EBVERSIONLIBJPEGMINTURBO = 2.0.2
EBVERSIONLIBPCIACCESS = 0.14
EBVERSIONLIBPNG = 1.6.37
EBVERSIONLIBREADLINE = 8.0
EBVERSIONLIBTIFF = 4.0.10
EBVERSIONLIBXML2 = 2.9.8
EBVERSIONNASM = 2.13.03
EBVERSIONNCURSES = 6.1
EBVERSIONNUMACTL = 2.0.11
EBVERSIONOPENBLAS = 0.3.1
EBVERSIONOPENMPI = 3.1.1
EBVERSIONPANGO = 1.43.0
EBVERSIONPCRE = 8.43
EBVERSIONPERL = 5.30.0
EBVERSIONPERLPLUS = 5.30.0
EBVERSIONPIXMAN = 0.38.4
EBVERSIONPYTHON = 2.7.16
EBVERSIONPYTHONPLUS = 2.7.16
EBVERSIONR = 3.6.1
EBVERSIONSAMTOOLS = 1.9
EBVERSIONSCALAPACK = 2.0.2
EBVERSIONSQLITE = 3.29.0
EBVERSIONTCL = 8.6.9
EBVERSIONUTILMINLINUX = 2.34
EBVERSIONVEP = 92.0
EBVERSIONXMLMINLIBXML = 2.0132
EBVERSIONXZ = 5.2.4
EBVERSIONZLIB = 1.2.11
FANCYLOGGER_IGNORE_MPI4PY = 1
FLEXO = 172.23.34.248
GI_TYPELIB_PATH = /apps/software/Pango/1.43.0-GCCcore-7.3.0/share:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/share
HISTCONTROL = ignoredups
HISTSIZE = 1000
HOME = /home/umcg-gvdvries
HOSTNAME = sugarsnax
HPC_ENV_PREFIX = /apps
JAVA_HOME = /apps/software/AdoptOpenJDK/11.0.4_11-hotspot
LANG = en_US.UTF-8
LD_LIBRARY_PATH = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib:/apps/software/HTSlib/1.9-GCCcore-7.3.0/lib:/apps/software/cURL/7.63.0-GCCcore-7.3.0/lib:/apps/software/bzip2/1.0.6-GCCcore-7.3.0/lib:/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib:/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib:/apps/software/R/3.6.1-foss-2018b-bare/lib64/R/lib:/apps/software/R/3.6.1-foss-2018b-bare/lib64:/apps/software/Pango/1.43.0-GCCcore-7.3.0/lib:/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/lib:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/lib:/apps/software/cairo/1.16.0-GCCcore-7.3.0/lib:/apps/software/GLib/2.61.1-GCCcore-7.3.0/lib:/apps/software/gettext/0.20.1-GCCcore-7.3.0/lib:/apps/software/pixman/0.38.4-GCCcore-7.3.0/lib:/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/lib:/apps/software/PCRE/8.43-GCCcore-7.3.0/lib:/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/lib:/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/lib:/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/lib64:/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/lib:/apps/software/util-linux/2.34-GCCcore-7.3.0/lib:/apps/software/ncurses/6.1-GCCcore-7.3.0/lib:/apps/software/freetype/2.10.1-GCCcore-7.3.0/lib:/apps/software/libpng/1.6.37-GCCcore-7.3.0/lib:/apps/software/expat/2.2.7-GCCcore-7.3.0/lib:/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/lib:/apps/software/SAMtools/1.9-foss-2018b/lib:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages/numpy-1.14.2-py2.7-linux-x86_64.egg/numpy/core/lib:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/lib:/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib64:/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib:/apps/software/GMP/6.1.2-GCCcore-7.3.0/lib:/apps/software/SQLite/3.29.0-GCCcore-7.3.0/lib:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/lib:/apps/software/libreadline/8.0-GCCcore-7.3.0/lib:/apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/lib:/apps/software/FFTW/3.3.8-gompi-2018b/lib:/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/lib:/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/lib:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/lib:/apps/software/libpciaccess/0.14-GCCcore-7.3.0/lib:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/lib:/apps/software/XZ/5.2.4-GCCcore-7.3.0/lib:/apps/software/numactl/2.0.11-GCCcore-7.3.0/lib:/apps/software/zlib/1.2.11-GCCcore-7.3.0/lib:/apps/software/binutils/2.30-GCCcore-7.3.0/lib:/apps/software/GCCcore/7.3.0/lib/gcc/x86_64-pc-linux-gnu/7.3.0:/apps/software/GCCcore/7.3.0/lib64:/apps/software/GCCcore/7.3.0/lib
LESSOPEN = ||/usr/bin/lesspipe.sh %s
LIBRARY_PATH = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib:/apps/software/HTSlib/1.9-GCCcore-7.3.0/lib:/apps/software/cURL/7.63.0-GCCcore-7.3.0/lib:/apps/software/bzip2/1.0.6-GCCcore-7.3.0/lib:/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib:/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib:/apps/software/R/3.6.1-foss-2018b-bare/lib64/R/lib:/apps/software/R/3.6.1-foss-2018b-bare/lib64:/apps/software/Pango/1.43.0-GCCcore-7.3.0/lib:/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/lib:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/lib:/apps/software/cairo/1.16.0-GCCcore-7.3.0/lib:/apps/software/GLib/2.61.1-GCCcore-7.3.0/lib:/apps/software/gettext/0.20.1-GCCcore-7.3.0/lib:/apps/software/pixman/0.38.4-GCCcore-7.3.0/lib:/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/lib:/apps/software/PCRE/8.43-GCCcore-7.3.0/lib:/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/lib:/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/lib:/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/lib64:/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/lib:/apps/software/util-linux/2.34-GCCcore-7.3.0/lib:/apps/software/ncurses/6.1-GCCcore-7.3.0/lib:/apps/software/freetype/2.10.1-GCCcore-7.3.0/lib:/apps/software/libpng/1.6.37-GCCcore-7.3.0/lib:/apps/software/expat/2.2.7-GCCcore-7.3.0/lib:/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/lib:/apps/software/SAMtools/1.9-foss-2018b/lib:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages/numpy-1.14.2-py2.7-linux-x86_64.egg/numpy/core/lib:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/lib:/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib64:/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib:/apps/software/GMP/6.1.2-GCCcore-7.3.0/lib:/apps/software/SQLite/3.29.0-GCCcore-7.3.0/lib:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/lib:/apps/software/libreadline/8.0-GCCcore-7.3.0/lib:/apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/lib:/apps/software/FFTW/3.3.8-gompi-2018b/lib:/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/lib:/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/lib:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/lib:/apps/software/libpciaccess/0.14-GCCcore-7.3.0/lib:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/lib:/apps/software/XZ/5.2.4-GCCcore-7.3.0/lib:/apps/software/numactl/2.0.11-GCCcore-7.3.0/lib:/apps/software/zlib/1.2.11-GCCcore-7.3.0/lib:/apps/software/binutils/2.30-GCCcore-7.3.0/lib:/apps/software/GCCcore/7.3.0/lib64:/apps/software/GCCcore/7.3.0/lib
LMOD_ADMIN_FILE = /apps/modules/modules.admin
LMOD_CACHE_DIR = /apps/modules/.lmod/cache/
LMOD_CASE_INDEPENDENT_SORTING = True
LMOD_CMD = /apps/software/lmod/lmod/libexec/lmod
LMOD_DIR = /apps/software/lmod/lmod/libexec
LMOD_PAGER = none
LMOD_PKG = /apps/software/lmod/lmod
LMOD_RC = /apps/modules/.lmod/lmodrc.lua
LMOD_REDIRECT = True
LMOD_SETTARG_FULL_SUPPORT = no
LMOD_TIMESTAMP_FILE = /apps/modules/.lmod/modules_changed.timestamp
LMOD_VERSION = 7.8.8
LOADEDMODULES = GCCcore/7.3.0:binutils/2.30-GCCcore-7.3.0:GCC/7.3.0-2.30:zlib/1.2.11-GCCcore-7.3.0:numactl/2.0.11-GCCcore-7.3.0:XZ/5.2.4-GCCcore-7.3.0:libxml2/2.9.8-GCCcore-7.3.0:libpciaccess/0.14-GCCcore-7.3.0:hwloc/1.11.10-GCCcore-7.3.0:OpenMPI/3.1.1-GCC-7.3.0-2.30:OpenBLAS/0.3.1-GCC-7.3.0-2.30:gompi/2018b:FFTW/3.3.8-gompi-2018b:ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1:foss/2018b:libreadline/8.0-GCCcore-7.3.0:Tcl/8.6.9-GCCcore-7.3.0:SQLite/3.29.0-GCCcore-7.3.0:GMP/6.1.2-GCCcore-7.3.0:libffi/3.2.1-GCCcore-7.3.0:Python/2.7.16-GCCcore-7.3.0-bare:PythonPlus/2.7.16-foss-2018b-v20.02.1:SAMtools/1.9-foss-2018b:Perl/5.30.0-GCCcore-7.3.0-bare:expat/2.2.7-GCCcore-7.3.0:libpng/1.6.37-GCCcore-7.3.0:freetype/2.10.1-GCCcore-7.3.0:ncurses/6.1-GCCcore-7.3.0:util-linux/2.34-GCCcore-7.3.0:fontconfig/2.13.1-GCCcore-7.3.0:NASM/2.13.03-GCCcore-7.3.0:libjpeg-turbo/2.0.2-GCCcore-7.3.0:libgd/2.2.5-GCCcore-7.3.0-lor:LibTIFF/4.0.10-GCCcore-7.3.0:PCRE/8.43-GCCcore-7.3.0:AdoptOpenJDK/11.0.4_11-hotspot:Java/11-LTS:pixman/0.38.4-GCCcore-7.3.0:gettext/0.20.1-GCCcore-7.3.0:GLib/2.61.1-GCCcore-7.3.0:cairo/1.16.0-GCCcore-7.3.0:HarfBuzz/2.5.3-GCCcore-7.3.0:FriBidi/1.0.5-GCCcore-7.3.0:Pango/1.43.0-GCCcore-7.3.0:R/3.6.1-foss-2018b-bare:PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1:XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0:Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0:bzip2/1.0.6-GCCcore-7.3.0:cURL/7.63.0-GCCcore-7.3.0:HTSlib/1.9-GCCcore-7.3.0:VEP/92.0-foss-2018b-Perl-5.30.0:CADD/v1.4-foss-2018b:BioPerl/1.7.2-foss-2018b-Perl-5.30.0:EasyBuild/3.9.3
LOGNAME = umcg-gvdvries
LS_COLORS = rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:
MAIL = /var/spool/mail/umcg-gvdvries
MANPATH = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/man:/apps/software/HTSlib/1.9-GCCcore-7.3.0/share/man:/apps/software/cURL/7.63.0-GCCcore-7.3.0/share/man:/apps/software/bzip2/1.0.6-GCCcore-7.3.0/man:/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/man:/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/man:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/man:/apps/software/R/3.6.1-foss-2018b-bare/share/man:/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/share/man:/apps/software/gettext/0.20.1-GCCcore-7.3.0/share/man:/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/man:/apps/software/PCRE/8.43-GCCcore-7.3.0/share/man:/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/share/man:/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/share/man:/apps/software/NASM/2.13.03-GCCcore-7.3.0/share/man:/apps/software/util-linux/2.34-GCCcore-7.3.0/share/man:/apps/software/ncurses/6.1-GCCcore-7.3.0/share/man:/apps/software/freetype/2.10.1-GCCcore-7.3.0/share/man:/apps/software/libpng/1.6.37-GCCcore-7.3.0/share/man:/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/man:/apps/software/SAMtools/1.9-foss-2018b/share/man:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/share/man:/apps/software/libffi/3.2.1-GCCcore-7.3.0/share/man:/apps/software/SQLite/3.29.0-GCCcore-7.3.0/share/man:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/share/man:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/man:/apps/software/libreadline/8.0-GCCcore-7.3.0/share/man:/apps/software/FFTW/3.3.8-gompi-2018b/share/man:/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/share/man:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/share/man:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/share/man:/apps/software/XZ/5.2.4-GCCcore-7.3.0/share/man:/apps/software/numactl/2.0.11-GCCcore-7.3.0/share/man:/apps/software/zlib/1.2.11-GCCcore-7.3.0/share/man:/apps/software/binutils/2.30-GCCcore-7.3.0/share/man:/apps/software/GCCcore/7.3.0/share/man
MODULEPATH = /apps/modules/vis:/apps/modules/tools:/apps/modules/toolchain:/apps/modules/system:/apps/modules/phys:/apps/modules/numlib:/apps/modules/mpi:/apps/modules/math:/apps/modules/lib:/apps/modules/lang:/apps/modules/devel:/apps/modules/data:/apps/modules/compiler:/apps/modules/bio
MODULESHOME = /apps/software/lmod/lmod
PATH = /apps/software/EasyBuild/3.9.3/bin:/apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/bin:/apps/software/CADD/v1.4-foss-2018b:/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/htslib:/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0:/apps/software/HTSlib/1.9-GCCcore-7.3.0/bin:/apps/software/cURL/7.63.0-GCCcore-7.3.0/bin:/apps/software/bzip2/1.0.6-GCCcore-7.3.0/bin:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/bin:/apps/software/R/3.6.1-foss-2018b-bare/bin:/apps/software/Pango/1.43.0-GCCcore-7.3.0/bin:/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/bin:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/bin:/apps/software/cairo/1.16.0-GCCcore-7.3.0/bin:/apps/software/GLib/2.61.1-GCCcore-7.3.0/bin:/apps/software/gettext/0.20.1-GCCcore-7.3.0/bin:/apps/software/AdoptOpenJDK/11.0.4_11-hotspot:/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/bin:/apps/software/PCRE/8.43-GCCcore-7.3.0/bin:/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/bin:/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/bin:/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/bin:/apps/software/NASM/2.13.03-GCCcore-7.3.0/bin:/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/bin:/apps/software/util-linux/2.34-GCCcore-7.3.0/sbin:/apps/software/util-linux/2.34-GCCcore-7.3.0/bin:/apps/software/ncurses/6.1-GCCcore-7.3.0/bin:/apps/software/freetype/2.10.1-GCCcore-7.3.0/bin:/apps/software/libpng/1.6.37-GCCcore-7.3.0/bin:/apps/software/expat/2.2.7-GCCcore-7.3.0/bin:/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/bin:/apps/software/SAMtools/1.9-foss-2018b/bin:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/bin:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/bin:/apps/software/SQLite/3.29.0-GCCcore-7.3.0/bin:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/bin:/apps/software/libreadline/8.0-GCCcore-7.3.0/bin:/apps/software/FFTW/3.3.8-gompi-2018b/bin:/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/bin:/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/bin:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/sbin:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/bin:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/bin:/apps/software/XZ/5.2.4-GCCcore-7.3.0/bin:/apps/software/numactl/2.0.11-GCCcore-7.3.0/bin:/apps/software/binutils/2.30-GCCcore-7.3.0/bin:/apps/software/GCCcore/7.3.0/bin:/apps/software/lmod/lmod/libexec:/apps/software/Lua/5.1.4.9/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/umcg-gvdvries/.local/bin:/home/umcg-gvdvries/bin
PERL5LIB = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0:/apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0/x86_64-linux-thread-multi:/apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0:/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/modules:/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/modules/api:/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0:/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0/x86_64-linux-thread-multi:/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0:/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib/perl5/site_perl/5.30.0:/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib/perl5/site_perl/5.30.0/x86_64-linux-thread-multi:/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib/perl5/site_perl/5.30.0:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib/perl5/site_perl:/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib/perl5
PKG_CONFIG_PATH = /apps/software/HTSlib/1.9-GCCcore-7.3.0/lib/pkgconfig:/apps/software/cURL/7.63.0-GCCcore-7.3.0/lib/pkgconfig:/apps/software/R/3.6.1-foss-2018b-bare/lib64/pkgconfig:/apps/software/Pango/1.43.0-GCCcore-7.3.0/lib/pkgconfig:/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/lib/pkgconfig:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/lib/pkgconfig:/apps/software/cairo/1.16.0-GCCcore-7.3.0/lib/pkgconfig:/apps/software/GLib/2.61.1-GCCcore-7.3.0/lib/pkgconfig:/apps/software/pixman/0.38.4-GCCcore-7.3.0/lib/pkgconfig:/apps/software/PCRE/8.43-GCCcore-7.3.0/lib/pkgconfig:/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/lib/pkgconfig:/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/lib/pkgconfig:/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/lib64/pkgconfig:/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/lib/pkgconfig:/apps/software/util-linux/2.34-GCCcore-7.3.0/lib/pkgconfig:/apps/software/freetype/2.10.1-GCCcore-7.3.0/lib/pkgconfig:/apps/software/libpng/1.6.37-GCCcore-7.3.0/lib/pkgconfig:/apps/software/expat/2.2.7-GCCcore-7.3.0/lib/pkgconfig:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/lib/pkgconfig:/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib/pkgconfig:/apps/software/SQLite/3.29.0-GCCcore-7.3.0/lib/pkgconfig:/apps/software/Tcl/8.6.9-GCCcore-7.3.0/lib/pkgconfig:/apps/software/libreadline/8.0-GCCcore-7.3.0/lib/pkgconfig:/apps/software/FFTW/3.3.8-gompi-2018b/lib/pkgconfig:/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/lib/pkgconfig:/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/lib/pkgconfig:/apps/software/hwloc/1.11.10-GCCcore-7.3.0/lib/pkgconfig:/apps/software/libpciaccess/0.14-GCCcore-7.3.0/lib/pkgconfig:/apps/software/libxml2/2.9.8-GCCcore-7.3.0/lib/pkgconfig:/apps/software/XZ/5.2.4-GCCcore-7.3.0/lib/pkgconfig:/apps/software/zlib/1.2.11-GCCcore-7.3.0/lib/pkgconfig
PWD = /home/umcg-gvdvries/easybuild-easyconfigs/easybuild/easyconfigs/n/NGS_DNA
PYTHONOPTIMIZE = 1
PYTHONPATH = /apps/software/EasyBuild/3.9.3/lib/python2.7/site-packages:/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages:/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/easybuild/python
SACCT_FORMAT = User%20,JobID%-13,JobName%25,QOS%16,State,ExitCode,Submit,Eligible,Start,End,ReqTRES%25,Timelimit,AllocTRES%25,NodeList,Elapsed,ExitCode
SACCT_FORMAT_ID_STATE = User%20,JobID%-13,JobName%25,QOS%16,State,ExitCode
SACCT_FORMAT_REQ_ALLOC = Submit,Eligible,Start,End,ReqTRES%25,Timelimit,AllocTRES%25,NodeList,Elapsed,ExitCode
SACCT_FORMAT_USED_AVE = AveCPU,AveDiskRead,AveDiskWrite,AvePages,AveRSS,AveVMSize
SACCT_FORMAT_USED_MAX = TotalCPU,MaxDiskRead,MaxDiskWrite,MaxPages,MaxRSS,MaxVMSize
SBATCH_EXPORT = NONE
SBATCH_GET_USER_ENV = 30L
SELINUX_LEVEL_REQUESTED = 
SELINUX_ROLE_REQUESTED = 
SELINUX_USE_CURRENT_RANGE = 
SHELL = /bin/bash
SHLVL = 2
SSH_CLIENT = 172.23.40.33 34190 22
SSH_CONNECTION = 172.23.40.33 34190 172.23.40.35 22
SSH_TTY = /dev/pts/0
TERM = xterm-256color
TEST_EASYBUILD_MODULES_TOOL = Lmod
USER = umcg-gvdvries
XDG_DATA_DIRS = /apps/software/Pango/1.43.0-GCCcore-7.3.0/share:/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/share
_ = /apps/software/Python/2.7.16-GCCcore-7.3.0-bare/bin/python2
_LMFILES_ = /apps/modules/compiler/GCCcore/7.3.0.lua:/apps/modules/tools/binutils/2.30-GCCcore-7.3.0.lua:/apps/modules/compiler/GCC/7.3.0-2.30.lua:/apps/modules/lib/zlib/1.2.11-GCCcore-7.3.0.lua:/apps/modules/tools/numactl/2.0.11-GCCcore-7.3.0.lua:/apps/modules/tools/XZ/5.2.4-GCCcore-7.3.0.lua:/apps/modules/lib/libxml2/2.9.8-GCCcore-7.3.0.lua:/apps/modules/system/libpciaccess/0.14-GCCcore-7.3.0.lua:/apps/modules/system/hwloc/1.11.10-GCCcore-7.3.0.lua:/apps/modules/mpi/OpenMPI/3.1.1-GCC-7.3.0-2.30.lua:/apps/modules/numlib/OpenBLAS/0.3.1-GCC-7.3.0-2.30.lua:/apps/modules/toolchain/gompi/2018b.lua:/apps/modules/numlib/FFTW/3.3.8-gompi-2018b.lua:/apps/modules/numlib/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1.lua:/apps/modules/toolchain/foss/2018b.lua:/apps/modules/lib/libreadline/8.0-GCCcore-7.3.0.lua:/apps/modules/lang/Tcl/8.6.9-GCCcore-7.3.0.lua:/apps/modules/devel/SQLite/3.29.0-GCCcore-7.3.0.lua:/apps/modules/math/GMP/6.1.2-GCCcore-7.3.0.lua:/apps/modules/lib/libffi/3.2.1-GCCcore-7.3.0.lua:/apps/modules/lang/Python/2.7.16-GCCcore-7.3.0-bare.lua:/apps/modules/lang/PythonPlus/2.7.16-foss-2018b-v20.02.1.lua:/apps/modules/bio/SAMtools/1.9-foss-2018b.lua:/apps/modules/lang/Perl/5.30.0-GCCcore-7.3.0-bare.lua:/apps/modules/tools/expat/2.2.7-GCCcore-7.3.0.lua:/apps/modules/lib/libpng/1.6.37-GCCcore-7.3.0.lua:/apps/modules/vis/freetype/2.10.1-GCCcore-7.3.0.lua:/apps/modules/devel/ncurses/6.1-GCCcore-7.3.0.lua:/apps/modules/tools/util-linux/2.34-GCCcore-7.3.0.lua:/apps/modules/vis/fontconfig/2.13.1-GCCcore-7.3.0.lua:/apps/modules/lang/NASM/2.13.03-GCCcore-7.3.0.lua:/apps/modules/lib/libjpeg-turbo/2.0.2-GCCcore-7.3.0.lua:/apps/modules/lib/libgd/2.2.5-GCCcore-7.3.0-lor.lua:/apps/modules/lib/LibTIFF/4.0.10-GCCcore-7.3.0.lua:/apps/modules/devel/PCRE/8.43-GCCcore-7.3.0.lua:/apps/modules/lang/AdoptOpenJDK/11.0.4_11-hotspot.lua:/apps/modules/lang/Java/11-LTS.lua:/apps/modules/vis/pixman/0.38.4-GCCcore-7.3.0.lua:/apps/modules/tools/gettext/0.20.1-GCCcore-7.3.0.lua:/apps/modules/vis/GLib/2.61.1-GCCcore-7.3.0.lua:/apps/modules/vis/cairo/1.16.0-GCCcore-7.3.0.lua:/apps/modules/vis/HarfBuzz/2.5.3-GCCcore-7.3.0.lua:/apps/modules/lang/FriBidi/1.0.5-GCCcore-7.3.0.lua:/apps/modules/vis/Pango/1.43.0-GCCcore-7.3.0.lua:/apps/modules/lang/R/3.6.1-foss-2018b-bare.lua:/apps/modules/lang/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1.lua:/apps/modules/data/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0.lua:/apps/modules/bio/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0.lua:/apps/modules/tools/bzip2/1.0.6-GCCcore-7.3.0.lua:/apps/modules/tools/cURL/7.63.0-GCCcore-7.3.0.lua:/apps/modules/bio/HTSlib/1.9-GCCcore-7.3.0.lua:/apps/modules/bio/VEP/92.0-foss-2018b-Perl-5.30.0.lua:/apps/modules/bio/CADD/v1.4-foss-2018b.lua:/apps/modules/bio/BioPerl/1.7.2-foss-2018b-Perl-5.30.0.lua:/apps/modules/tools/EasyBuild/3.9.3.lua
_ModuleTable001_ = X01vZHVsZVRhYmxlXz17WyJNVHZlcnNpb24iXT0zLFsiY19yZWJ1aWxkVGltZSJdPTg2NDAwLFsiY19zaG9ydFRpbWUiXT1mYWxzZSxkZXB0aFQ9e30sZmFtaWx5PXt9LG1UPXtBZG9wdE9wZW5KREs9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9sYW5nL0Fkb3B0T3BlbkpESy8xMS4wLjRfMTEtaG90c3BvdC5sdWEiLFsiZnVsbE5hbWUiXT0iQWRvcHRPcGVuSkRLLzExLjAuNF8xMS1ob3RzcG90IixbImxvYWRPcmRlciJdPTM2LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTUsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IkFkb3B0T3BlbkpESy8xMS4wLjRfMTEtaG90c3BvdCIsfSxbIkJpby1EQi1IVFMiXT17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2Jpby9CaW8tREIt
_ModuleTable002_ = SFRTLzIuMTEtZm9zcy0yMDE4Yi1QZXJsLTUuMzAuMC5sdWEiLFsiZnVsbE5hbWUiXT0iQmlvLURCLUhUUy8yLjExLWZvc3MtMjAxOGItUGVybC01LjMwLjAiLFsibG9hZE9yZGVyIl09NDgscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09MixbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iQmlvLURCLUhUUy8yLjExLWZvc3MtMjAxOGItUGVybC01LjMwLjAiLH0sQmlvUGVybD17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2Jpby9CaW9QZXJsLzEuNy4yLWZvc3MtMjAxOGItUGVybC01LjMwLjAubHVhIixbImZ1bGxOYW1lIl09IkJpb1BlcmwvMS43LjItZm9zcy0yMDE4Yi1QZXJsLTUuMzAuMCIsWyJsb2FkT3JkZXIiXT01NCxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0wLFsi
_ModuleTable003_ = c3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJCaW9QZXJsLzEuNy4yLWZvc3MtMjAxOGItUGVybC01LjMwLjAiLH0sQ0FERD17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2Jpby9DQUREL3YxLjQtZm9zcy0yMDE4Yi5sdWEiLFsiZnVsbE5hbWUiXT0iQ0FERC92MS40LWZvc3MtMjAxOGIiLFsibG9hZE9yZGVyIl09NTMscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09MCxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iQ0FERCIsfSxFYXN5QnVpbGQ9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy90b29scy9FYXN5QnVpbGQvMy45LjMubHVhIixbImZ1bGxOYW1lIl09IkVhc3lCdWlsZC8zLjkuMyIsWyJsb2FkT3JkZXIiXT01NSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0w
_ModuleTable004_ = LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJFYXN5QnVpbGQiLH0sRkZUVz17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL251bWxpYi9GRlRXLzMuMy44LWdvbXBpLTIwMThiLmx1YSIsWyJmdWxsTmFtZSJdPSJGRlRXLzMuMy44LWdvbXBpLTIwMThiIixbImxvYWRPcmRlciJdPTEzLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTIsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IkZGVFcvMy4zLjgtZ29tcGktMjAxOGIiLH0sRnJpQmlkaT17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2xhbmcvRnJpQmlkaS8xLjAuNS1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJGcmlCaWRpLzEuMC41LUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09NDMscHJv
_ModuleTable005_ = cFQ9e30sWyJzdGFja0RlcHRoIl09NSxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iRnJpQmlkaS8xLjAuNS1HQ0Njb3JlLTcuMy4wIix9LEdDQz17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2NvbXBpbGVyL0dDQy83LjMuMC0yLjMwLmx1YSIsWyJmdWxsTmFtZSJdPSJHQ0MvNy4zLjAtMi4zMCIsWyJsb2FkT3JkZXIiXT0zLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTIsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IkdDQy83LjMuMC0yLjMwIix9LEdDQ2NvcmU9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9jb21waWxlci9HQ0Njb3JlLzcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJHQ0Njb3JlLzcuMy4wIixbImxvYWRPcmRlciJdPTEscHJvcFQ9e30sWyJz
_ModuleTable006_ = dGFja0RlcHRoIl09MyxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iR0NDY29yZS83LjMuMCIsfSxHTGliPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdmlzL0dMaWIvMi42MS4xLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09IkdMaWIvMi42MS4xLUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09NDAscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09NSxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iR0xpYi8yLjYxLjEtR0NDY29yZS03LjMuMCIsfSxHTVA9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9tYXRoL0dNUC82LjEuMi1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJHTVAvNi4xLjItR0NDY29yZS03LjMuMCIsWyJsb2FkT3Jk
_ModuleTable007_ = ZXIiXT0xOSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJHTVAvNi4xLjItR0NDY29yZS03LjMuMCIsfSxIVFNsaWI9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9iaW8vSFRTbGliLzEuOS1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJIVFNsaWIvMS45LUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09NTEscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09MixbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iSFRTbGliLzEuOS1HQ0Njb3JlLTcuMy4wIix9LEhhcmZCdXp6PXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdmlzL0hhcmZCdXp6LzIuNS4zLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1l
_ModuleTable008_ = Il09IkhhcmZCdXp6LzIuNS4zLUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09NDIscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09NSxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iSGFyZkJ1enovMi41LjMtR0NDY29yZS03LjMuMCIsfSxKYXZhPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvbGFuZy9KYXZhLzExLUxUUy5sdWEiLFsiZnVsbE5hbWUiXT0iSmF2YS8xMS1MVFMiLFsibG9hZE9yZGVyIl09MzcscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09NCxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iSmF2YS8xMS1MVFMiLH0sTGliVElGRj17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2xpYi9MaWJUSUZGLzQuMC4xMC1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJm
_ModuleTable009_ = dWxsTmFtZSJdPSJMaWJUSUZGLzQuMC4xMC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTM0LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IkxpYlRJRkYvNC4wLjEwLUdDQ2NvcmUtNy4zLjAiLH0sTkFTTT17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2xhbmcvTkFTTS8yLjEzLjAzLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09Ik5BU00vMi4xMy4wMy1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTMxLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTUsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09Ik5BU00vMi4xMy4wMy1HQ0Njb3JlLTcuMy4wIix9LE9wZW5CTEFTPXtbImZuIl09Ii9h
_ModuleTable010_ = cHBzL21vZHVsZXMvbnVtbGliL09wZW5CTEFTLzAuMy4xLUdDQy03LjMuMC0yLjMwLmx1YSIsWyJmdWxsTmFtZSJdPSJPcGVuQkxBUy8wLjMuMS1HQ0MtNy4zLjAtMi4zMCIsWyJsb2FkT3JkZXIiXT0xMSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0yLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJPcGVuQkxBUy8wLjMuMS1HQ0MtNy4zLjAtMi4zMCIsfSxPcGVuTVBJPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvbXBpL09wZW5NUEkvMy4xLjEtR0NDLTcuMy4wLTIuMzAubHVhIixbImZ1bGxOYW1lIl09Ik9wZW5NUEkvMy4xLjEtR0NDLTcuMy4wLTIuMzAiLFsibG9hZE9yZGVyIl09MTAscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09MixbInN0YXR1cyJdPSJhY3RpdmUi
_ModuleTable011_ = LFsidXNlck5hbWUiXT0iT3Blbk1QSS8zLjEuMS1HQ0MtNy4zLjAtMi4zMCIsfSxQQ1JFPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvZGV2ZWwvUENSRS84LjQzLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09IlBDUkUvOC40My1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTM1LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTQsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IlBDUkUvOC40My1HQ0Njb3JlLTcuMy4wIix9LFBhbmdvPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdmlzL1BhbmdvLzEuNDMuMC1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJQYW5nby8xLjQzLjAtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT00NCxwcm9wVD17
_ModuleTable012_ = fSxbInN0YWNrRGVwdGgiXT00LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJQYW5nby8xLjQzLjAtR0NDY29yZS03LjMuMCIsfSxQZXJsPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvbGFuZy9QZXJsLzUuMzAuMC1HQ0Njb3JlLTcuMy4wLWJhcmUubHVhIixbImZ1bGxOYW1lIl09IlBlcmwvNS4zMC4wLUdDQ2NvcmUtNy4zLjAtYmFyZSIsWyJsb2FkT3JkZXIiXT0yNCxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJQZXJsLzUuMzAuMC1HQ0Njb3JlLTcuMy4wLWJhcmUiLH0sUGVybFBsdXM9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9sYW5nL1BlcmxQbHVzLzUuMzAuMC1HQ0Njb3JlLTcuMy4wLXYxOS4wOC4x
_ModuleTable013_ = Lmx1YSIsWyJmdWxsTmFtZSJdPSJQZXJsUGx1cy81LjMwLjAtR0NDY29yZS03LjMuMC12MTkuMDguMSIsWyJsb2FkT3JkZXIiXT00Nixwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0yLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJQZXJsUGx1cy81LjMwLjAtR0NDY29yZS03LjMuMC12MTkuMDguMSIsfSxQeXRob249e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9sYW5nL1B5dGhvbi8yLjcuMTYtR0NDY29yZS03LjMuMC1iYXJlLmx1YSIsWyJmdWxsTmFtZSJdPSJQeXRob24vMi43LjE2LUdDQ2NvcmUtNy4zLjAtYmFyZSIsWyJsb2FkT3JkZXIiXT0yMSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0yLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJQeXRob24v
_ModuleTable014_ = Mi43LjE2LUdDQ2NvcmUtNy4zLjAtYmFyZSIsfSxQeXRob25QbHVzPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvbGFuZy9QeXRob25QbHVzLzIuNy4xNi1mb3NzLTIwMThiLXYyMC4wMi4xLmx1YSIsWyJmdWxsTmFtZSJdPSJQeXRob25QbHVzLzIuNy4xNi1mb3NzLTIwMThiLXYyMC4wMi4xIixbImxvYWRPcmRlciJdPTIyLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTEsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IlB5dGhvblBsdXMvMi43LjE2LWZvc3MtMjAxOGItdjIwLjAyLjEiLH0sUj17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2xhbmcvUi8zLjYuMS1mb3NzLTIwMThiLWJhcmUubHVhIixbImZ1bGxOYW1lIl09IlIvMy42LjEtZm9zcy0yMDE4Yi1iYXJlIixbImxv
_ModuleTable015_ = YWRPcmRlciJdPTQ1LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IlIvMy42LjEtZm9zcy0yMDE4Yi1iYXJlIix9LFNBTXRvb2xzPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvYmlvL1NBTXRvb2xzLzEuOS1mb3NzLTIwMThiLmx1YSIsWyJmdWxsTmFtZSJdPSJTQU10b29scy8xLjktZm9zcy0yMDE4YiIsWyJsb2FkT3JkZXIiXT0yMyxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0xLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJTQU10b29scy8xLjktZm9zcy0yMDE4YiIsfSxTUUxpdGU9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9kZXZlbC9TUUxpdGUvMy4yOS4wLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxO
_ModuleTable016_ = YW1lIl09IlNRTGl0ZS8zLjI5LjAtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0xOCxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJTUUxpdGUvMy4yOS4wLUdDQ2NvcmUtNy4zLjAiLH0sU2NhTEFQQUNLPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvbnVtbGliL1NjYUxBUEFDSy8yLjAuMi1nb21waS0yMDE4Yi1PcGVuQkxBUy0wLjMuMS5sdWEiLFsiZnVsbE5hbWUiXT0iU2NhTEFQQUNLLzIuMC4yLWdvbXBpLTIwMThiLU9wZW5CTEFTLTAuMy4xIixbImxvYWRPcmRlciJdPTE0LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTIsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IlNjYUxBUEFDSy8yLjAuMi1n
_ModuleTable017_ = b21waS0yMDE4Yi1PcGVuQkxBUy0wLjMuMSIsfSxUY2w9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9sYW5nL1RjbC84LjYuOS1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJUY2wvOC42LjktR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0xNyxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT00LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJUY2wvOC42LjktR0NDY29yZS03LjMuMCIsfSxWRVA9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9iaW8vVkVQLzkyLjAtZm9zcy0yMDE4Yi1QZXJsLTUuMzAuMC5sdWEiLFsiZnVsbE5hbWUiXT0iVkVQLzkyLjAtZm9zcy0yMDE4Yi1QZXJsLTUuMzAuMCIsWyJsb2FkT3JkZXIiXT01Mixwcm9wVD17fSxbInN0YWNrRGVw
_ModuleTable018_ = dGgiXT0xLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJWRVAvOTIuMC1mb3NzLTIwMThiLVBlcmwtNS4zMC4wIix9LFsiWE1MLUxpYlhNTCJdPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvZGF0YS9YTUwtTGliWE1MLzIuMDEzMi1HQ0Njb3JlLTcuMy4wLVBlcmwtNS4zMC4wLmx1YSIsWyJmdWxsTmFtZSJdPSJYTUwtTGliWE1MLzIuMDEzMi1HQ0Njb3JlLTcuMy4wLVBlcmwtNS4zMC4wIixbImxvYWRPcmRlciJdPTQ3LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IlhNTC1MaWJYTUwvMi4wMTMyLUdDQ2NvcmUtNy4zLjAtUGVybC01LjMwLjAiLH0sWFo9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy90b29scy9Y
_ModuleTable019_ = Wi81LjIuNC1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJYWi81LjIuNC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTYscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09NSxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iWFovNS4yLjQtR0NDY29yZS03LjMuMCIsfSxiaW51dGlscz17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL3Rvb2xzL2JpbnV0aWxzLzIuMzAtR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0iYmludXRpbHMvMi4zMC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTIscHJvcFQ9e30sWyJzdGFja0RlcHRoIl09MyxbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0iYmludXRpbHMvMi4zMC1HQ0Njb3JlLTcuMy4w
_ModuleTable020_ = Iix9LGJ6aXAyPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdG9vbHMvYnppcDIvMS4wLjYtR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0iYnppcDIvMS4wLjYtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT00OSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJiemlwMi8xLjAuNi1HQ0Njb3JlLTcuMy4wIix9LGNVUkw9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy90b29scy9jVVJMLzcuNjMuMC1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJjVVJMLzcuNjMuMC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTUwLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZl
_ModuleTable021_ = IixbInVzZXJOYW1lIl09ImNVUkwvNy42My4wLUdDQ2NvcmUtNy4zLjAiLH0sY2Fpcm89e1siZm4iXT0iL2FwcHMvbW9kdWxlcy92aXMvY2Fpcm8vMS4xNi4wLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09ImNhaXJvLzEuMTYuMC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTQxLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTQsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09ImNhaXJvLzEuMTYuMC1HQ0Njb3JlLTcuMy4wIix9LGV4cGF0PXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdG9vbHMvZXhwYXQvMi4yLjctR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0iZXhwYXQvMi4yLjctR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0yNSxw
_ModuleTable022_ = cm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJleHBhdC8yLjIuNy1HQ0Njb3JlLTcuMy4wIix9LGZvbnRjb25maWc9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy92aXMvZm9udGNvbmZpZy8yLjEzLjEtR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0iZm9udGNvbmZpZy8yLjEzLjEtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0zMCxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT00LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJmb250Y29uZmlnLzIuMTMuMS1HQ0Njb3JlLTcuMy4wIix9LGZvc3M9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy90b29sY2hhaW4vZm9zcy8yMDE4Yi5sdWEiLFsiZnVsbE5h
_ModuleTable023_ = bWUiXT0iZm9zcy8yMDE4YiIsWyJsb2FkT3JkZXIiXT0xNSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0xLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJmb3NzLzIwMThiIix9LGZyZWV0eXBlPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdmlzL2ZyZWV0eXBlLzIuMTAuMS1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJmcmVldHlwZS8yLjEwLjEtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0yNyxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT01LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJmcmVldHlwZS8yLjEwLjEtR0NDY29yZS03LjMuMCIsfSxnZXR0ZXh0PXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdG9vbHMvZ2V0dGV4dC8wLjIw
_ModuleTable024_ = LjEtR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0iZ2V0dGV4dC8wLjIwLjEtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0zOSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT02LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJnZXR0ZXh0LzAuMjAuMS1HQ0Njb3JlLTcuMy4wIix9LGdvbXBpPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdG9vbGNoYWluL2dvbXBpLzIwMThiLmx1YSIsWyJmdWxsTmFtZSJdPSJnb21waS8yMDE4YiIsWyJsb2FkT3JkZXIiXT0xMixwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJnb21waS8yMDE4YiIsfSxod2xvYz17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL3N5c3Rl
_ModuleTable025_ = bS9od2xvYy8xLjExLjEwLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09Imh3bG9jLzEuMTEuMTAtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT05LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09Imh3bG9jLzEuMTEuMTAtR0NDY29yZS03LjMuMCIsfSxsaWJmZmk9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9saWIvbGliZmZpLzMuMi4xLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09ImxpYmZmaS8zLjIuMS1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTIwLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09ImxpYmZmaS8zLjIuMS1H
_ModuleTable026_ = Q0Njb3JlLTcuMy4wIix9LGxpYmdkPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvbGliL2xpYmdkLzIuMi41LUdDQ2NvcmUtNy4zLjAtbG9yLmx1YSIsWyJmdWxsTmFtZSJdPSJsaWJnZC8yLjIuNS1HQ0Njb3JlLTcuMy4wLWxvciIsWyJsb2FkT3JkZXIiXT0zMyxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJsaWJnZC8yLjIuNS1HQ0Njb3JlLTcuMy4wLWxvciIsfSxbImxpYmpwZWctdHVyYm8iXT17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2xpYi9saWJqcGVnLXR1cmJvLzIuMC4yLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09ImxpYmpwZWctdHVyYm8vMi4wLjItR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIi
_ModuleTable027_ = XT0zMixwcm9wVD17fSxbInN0YWNrRGVwdGgiXT00LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJsaWJqcGVnLXR1cmJvLzIuMC4yLUdDQ2NvcmUtNy4zLjAiLH0sbGlicGNpYWNjZXNzPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvc3lzdGVtL2xpYnBjaWFjY2Vzcy8wLjE0LUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09ImxpYnBjaWFjY2Vzcy8wLjE0LUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09OCxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT00LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJsaWJwY2lhY2Nlc3MvMC4xNC1HQ0Njb3JlLTcuMy4wIix9LGxpYnBuZz17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2xpYi9saWJwbmcvMS42
_ModuleTable028_ = LjM3LUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09ImxpYnBuZy8xLjYuMzctR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0yNixwcm9wVD17fSxbInN0YWNrRGVwdGgiXT02LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJsaWJwbmcvMS42LjM3LUdDQ2NvcmUtNy4zLjAiLH0sbGlicmVhZGxpbmU9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9saWIvbGlicmVhZGxpbmUvOC4wLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09ImxpYnJlYWRsaW5lLzguMC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTE2LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTMsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09ImxpYnJlYWRsaW5lLzgu
_ModuleTable029_ = MC1HQ0Njb3JlLTcuMy4wIix9LGxpYnhtbDI9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy9saWIvbGlieG1sMi8yLjkuOC1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJsaWJ4bWwyLzIuOS44LUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09Nyxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT00LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJsaWJ4bWwyLzIuOS44LUdDQ2NvcmUtNy4zLjAiLH0sbmN1cnNlcz17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL2RldmVsL25jdXJzZXMvNi4xLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09Im5jdXJzZXMvNi4xLUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09MjgscHJvcFQ9e30sWyJzdGFja0RlcHRo
_ModuleTable030_ = Il09NixbInN0YXR1cyJdPSJhY3RpdmUiLFsidXNlck5hbWUiXT0ibmN1cnNlcy82LjEtR0NDY29yZS03LjMuMCIsfSxudW1hY3RsPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdG9vbHMvbnVtYWN0bC8yLjAuMTEtR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0ibnVtYWN0bC8yLjAuMTEtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT01LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTQsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09Im51bWFjdGwvMi4wLjExLUdDQ2NvcmUtNy4zLjAiLH0scGl4bWFuPXtbImZuIl09Ii9hcHBzL21vZHVsZXMvdmlzL3BpeG1hbi8wLjM4LjQtR0NDY29yZS03LjMuMC5sdWEiLFsiZnVsbE5hbWUiXT0icGl4bWFuLzAuMzgu
_ModuleTable031_ = NC1HQ0Njb3JlLTcuMy4wIixbImxvYWRPcmRlciJdPTM4LHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTUsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09InBpeG1hbi8wLjM4LjQtR0NDY29yZS03LjMuMCIsfSxbInV0aWwtbGludXgiXT17WyJmbiJdPSIvYXBwcy9tb2R1bGVzL3Rvb2xzL3V0aWwtbGludXgvMi4zNC1HQ0Njb3JlLTcuMy4wLmx1YSIsWyJmdWxsTmFtZSJdPSJ1dGlsLWxpbnV4LzIuMzQtR0NDY29yZS03LjMuMCIsWyJsb2FkT3JkZXIiXT0yOSxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT01LFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJ1dGlsLWxpbnV4LzIuMzQtR0NDY29yZS03LjMuMCIsfSx6bGliPXtbImZuIl09Ii9hcHBzL21vZHVs
_ModuleTable032_ = ZXMvbGliL3psaWIvMS4yLjExLUdDQ2NvcmUtNy4zLjAubHVhIixbImZ1bGxOYW1lIl09InpsaWIvMS4yLjExLUdDQ2NvcmUtNy4zLjAiLFsibG9hZE9yZGVyIl09NCxwcm9wVD17fSxbInN0YWNrRGVwdGgiXT0zLFsic3RhdHVzIl09ImFjdGl2ZSIsWyJ1c2VyTmFtZSJdPSJ6bGliLzEuMi4xMS1HQ0Njb3JlLTcuMy4wIix9LH0sbXBhdGhBPXsiL2FwcHMvbW9kdWxlcy92aXMiLCIvYXBwcy9tb2R1bGVzL3Rvb2xzIiwiL2FwcHMvbW9kdWxlcy90b29sY2hhaW4iLCIvYXBwcy9tb2R1bGVzL3N5c3RlbSIsIi9hcHBzL21vZHVsZXMvcGh5cyIsIi9hcHBzL21vZHVsZXMvbnVtbGliIiwiL2FwcHMvbW9kdWxlcy9tcGkiLCIvYXBwcy9tb2R1bGVzL21hdGgiLCIvYXBwcy9tb2R1bGVz
_ModuleTable033_ = L2xpYiIsIi9hcHBzL21vZHVsZXMvbGFuZyIsIi9hcHBzL21vZHVsZXMvZGV2ZWwiLCIvYXBwcy9tb2R1bGVzL2RhdGEiLCIvYXBwcy9tb2R1bGVzL2NvbXBpbGVyIiwiL2FwcHMvbW9kdWxlcy9iaW8iLH0sfQ==
_ModuleTable_Sz_ = 33
__LMOD_REF_COUNT_ACLOCAL_PATH = /apps/software/cURL/7.63.0-GCCcore-7.3.0/share/aclocal:1;/apps/software/GLib/2.61.1-GCCcore-7.3.0/share/aclocal:1;/apps/software/gettext/0.20.1-GCCcore-7.3.0/share/aclocal:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/share/aclocal:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/share/aclocal:1
__LMOD_REF_COUNT_CPATH = /apps/software/HTSlib/1.9-GCCcore-7.3.0/include:1;/apps/software/cURL/7.63.0-GCCcore-7.3.0/include:1;/apps/software/bzip2/1.0.6-GCCcore-7.3.0/include:1;/apps/software/Pango/1.43.0-GCCcore-7.3.0/include:1;/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/include:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/include:1;/apps/software/cairo/1.16.0-GCCcore-7.3.0/include:1;/apps/software/GLib/2.61.1-GCCcore-7.3.0/include:1;/apps/software/gettext/0.20.1-GCCcore-7.3.0/include:1;/apps/software/pixman/0.38.4-GCCcore-7.3.0/include:1;/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/include:1;/apps/software/PCRE/8.43-GCCcore-7.3.0/include:1;/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/include:1;/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/include:1;/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/include:1;/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/include:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/include:1;/apps/software/ncurses/6.1-GCCcore-7.3.0/include:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/include/freetype2:1;/apps/software/libpng/1.6.37-GCCcore-7.3.0/include:1;/apps/software/expat/2.2.7-GCCcore-7.3.0/include:1;/apps/software/SAMtools/1.9-foss-2018b/include:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages/numpy-1.14.2-py2.7-linux-x86_64.egg/numpy/core/include:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/include:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/include:1;/apps/software/GMP/6.1.2-GCCcore-7.3.0/include:1;/apps/software/SQLite/3.29.0-GCCcore-7.3.0/include:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/include:1;/apps/software/libreadline/8.0-GCCcore-7.3.0/include:1;/apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/include:1;/apps/software/FFTW/3.3.8-gompi-2018b/include:1;/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/include:1;/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/include:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/include:1;/apps/software/libpciaccess/0.14-GCCcore-7.3.0/include:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/include/libxml2:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/include:1;/apps/software/XZ/5.2.4-GCCcore-7.3.0/include:1;/apps/software/numactl/2.0.11-GCCcore-7.3.0/include:1;/apps/software/zlib/1.2.11-GCCcore-7.3.0/include:1;/apps/software/binutils/2.30-GCCcore-7.3.0/include:1;/apps/software/GCCcore/7.3.0/include:1
__LMOD_REF_COUNT_GI_TYPELIB_PATH = /apps/software/Pango/1.43.0-GCCcore-7.3.0/share:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/share:1
__LMOD_REF_COUNT_LD_LIBRARY_PATH = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib:1;/apps/software/HTSlib/1.9-GCCcore-7.3.0/lib:1;/apps/software/cURL/7.63.0-GCCcore-7.3.0/lib:1;/apps/software/bzip2/1.0.6-GCCcore-7.3.0/lib:1;/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib:1;/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib:1;/apps/software/R/3.6.1-foss-2018b-bare/lib64/R/lib:1;/apps/software/R/3.6.1-foss-2018b-bare/lib64:1;/apps/software/Pango/1.43.0-GCCcore-7.3.0/lib:1;/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/lib:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/lib:1;/apps/software/cairo/1.16.0-GCCcore-7.3.0/lib:1;/apps/software/GLib/2.61.1-GCCcore-7.3.0/lib:1;/apps/software/gettext/0.20.1-GCCcore-7.3.0/lib:1;/apps/software/pixman/0.38.4-GCCcore-7.3.0/lib:1;/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/lib:1;/apps/software/PCRE/8.43-GCCcore-7.3.0/lib:1;/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/lib:1;/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/lib:1;/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/lib64:1;/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/lib:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/lib:1;/apps/software/ncurses/6.1-GCCcore-7.3.0/lib:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/lib:1;/apps/software/libpng/1.6.37-GCCcore-7.3.0/lib:1;/apps/software/expat/2.2.7-GCCcore-7.3.0/lib:1;/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/lib:1;/apps/software/SAMtools/1.9-foss-2018b/lib:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages/numpy-1.14.2-py2.7-linux-x86_64.egg/numpy/core/lib:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/lib:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib64:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib:1;/apps/software/GMP/6.1.2-GCCcore-7.3.0/lib:1;/apps/software/SQLite/3.29.0-GCCcore-7.3.0/lib:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/lib:1;/apps/software/libreadline/8.0-GCCcore-7.3.0/lib:1;/apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/lib:1;/apps/software/FFTW/3.3.8-gompi-2018b/lib:1;/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/lib:1;/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/lib:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/lib:1;/apps/software/libpciaccess/0.14-GCCcore-7.3.0/lib:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/lib:1;/apps/software/XZ/5.2.4-GCCcore-7.3.0/lib:1;/apps/software/numactl/2.0.11-GCCcore-7.3.0/lib:1;/apps/software/zlib/1.2.11-GCCcore-7.3.0/lib:1;/apps/software/binutils/2.30-GCCcore-7.3.0/lib:1;/apps/software/GCCcore/7.3.0/lib/gcc/x86_64-pc-linux-gnu/7.3.0:1;/apps/software/GCCcore/7.3.0/lib64:1;/apps/software/GCCcore/7.3.0/lib:1
__LMOD_REF_COUNT_LIBRARY_PATH = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib:1;/apps/software/HTSlib/1.9-GCCcore-7.3.0/lib:1;/apps/software/cURL/7.63.0-GCCcore-7.3.0/lib:1;/apps/software/bzip2/1.0.6-GCCcore-7.3.0/lib:1;/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib:1;/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib:1;/apps/software/R/3.6.1-foss-2018b-bare/lib64/R/lib:1;/apps/software/R/3.6.1-foss-2018b-bare/lib64:1;/apps/software/Pango/1.43.0-GCCcore-7.3.0/lib:1;/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/lib:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/lib:1;/apps/software/cairo/1.16.0-GCCcore-7.3.0/lib:1;/apps/software/GLib/2.61.1-GCCcore-7.3.0/lib:1;/apps/software/gettext/0.20.1-GCCcore-7.3.0/lib:1;/apps/software/pixman/0.38.4-GCCcore-7.3.0/lib:1;/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/lib:1;/apps/software/PCRE/8.43-GCCcore-7.3.0/lib:1;/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/lib:1;/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/lib:1;/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/lib64:1;/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/lib:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/lib:1;/apps/software/ncurses/6.1-GCCcore-7.3.0/lib:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/lib:1;/apps/software/libpng/1.6.37-GCCcore-7.3.0/lib:1;/apps/software/expat/2.2.7-GCCcore-7.3.0/lib:1;/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/lib:1;/apps/software/SAMtools/1.9-foss-2018b/lib:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages/numpy-1.14.2-py2.7-linux-x86_64.egg/numpy/core/lib:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/lib:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib64:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib:1;/apps/software/GMP/6.1.2-GCCcore-7.3.0/lib:1;/apps/software/SQLite/3.29.0-GCCcore-7.3.0/lib:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/lib:1;/apps/software/libreadline/8.0-GCCcore-7.3.0/lib:1;/apps/software/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1/lib:1;/apps/software/FFTW/3.3.8-gompi-2018b/lib:1;/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/lib:1;/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/lib:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/lib:1;/apps/software/libpciaccess/0.14-GCCcore-7.3.0/lib:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/lib:1;/apps/software/XZ/5.2.4-GCCcore-7.3.0/lib:1;/apps/software/numactl/2.0.11-GCCcore-7.3.0/lib:1;/apps/software/zlib/1.2.11-GCCcore-7.3.0/lib:1;/apps/software/binutils/2.30-GCCcore-7.3.0/lib:1;/apps/software/GCCcore/7.3.0/lib64:1;/apps/software/GCCcore/7.3.0/lib:1
__LMOD_REF_COUNT_LOADEDMODULES = GCCcore/7.3.0:1;binutils/2.30-GCCcore-7.3.0:1;GCC/7.3.0-2.30:1;zlib/1.2.11-GCCcore-7.3.0:1;numactl/2.0.11-GCCcore-7.3.0:1;XZ/5.2.4-GCCcore-7.3.0:1;libxml2/2.9.8-GCCcore-7.3.0:1;libpciaccess/0.14-GCCcore-7.3.0:1;hwloc/1.11.10-GCCcore-7.3.0:1;OpenMPI/3.1.1-GCC-7.3.0-2.30:1;OpenBLAS/0.3.1-GCC-7.3.0-2.30:1;gompi/2018b:1;FFTW/3.3.8-gompi-2018b:1;ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1:1;foss/2018b:1;libreadline/8.0-GCCcore-7.3.0:1;Tcl/8.6.9-GCCcore-7.3.0:1;SQLite/3.29.0-GCCcore-7.3.0:1;GMP/6.1.2-GCCcore-7.3.0:1;libffi/3.2.1-GCCcore-7.3.0:1;Python/2.7.16-GCCcore-7.3.0-bare:1;PythonPlus/2.7.16-foss-2018b-v20.02.1:1;SAMtools/1.9-foss-2018b:1;Perl/5.30.0-GCCcore-7.3.0-bare:1;expat/2.2.7-GCCcore-7.3.0:1;libpng/1.6.37-GCCcore-7.3.0:1;freetype/2.10.1-GCCcore-7.3.0:1;ncurses/6.1-GCCcore-7.3.0:1;util-linux/2.34-GCCcore-7.3.0:1;fontconfig/2.13.1-GCCcore-7.3.0:1;NASM/2.13.03-GCCcore-7.3.0:1;libjpeg-turbo/2.0.2-GCCcore-7.3.0:1;libgd/2.2.5-GCCcore-7.3.0-lor:1;LibTIFF/4.0.10-GCCcore-7.3.0:1;PCRE/8.43-GCCcore-7.3.0:1;AdoptOpenJDK/11.0.4_11-hotspot:1;Java/11-LTS:1;pixman/0.38.4-GCCcore-7.3.0:1;gettext/0.20.1-GCCcore-7.3.0:1;GLib/2.61.1-GCCcore-7.3.0:1;cairo/1.16.0-GCCcore-7.3.0:1;HarfBuzz/2.5.3-GCCcore-7.3.0:1;FriBidi/1.0.5-GCCcore-7.3.0:1;Pango/1.43.0-GCCcore-7.3.0:1;R/3.6.1-foss-2018b-bare:1;PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1:1;XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0:1;Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0:1;bzip2/1.0.6-GCCcore-7.3.0:1;cURL/7.63.0-GCCcore-7.3.0:1;HTSlib/1.9-GCCcore-7.3.0:1;VEP/92.0-foss-2018b-Perl-5.30.0:1;CADD/v1.4-foss-2018b:1;BioPerl/1.7.2-foss-2018b-Perl-5.30.0:1;EasyBuild/3.9.3:1
__LMOD_REF_COUNT_MANPATH = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/man:1;/apps/software/HTSlib/1.9-GCCcore-7.3.0/share/man:1;/apps/software/cURL/7.63.0-GCCcore-7.3.0/share/man:1;/apps/software/bzip2/1.0.6-GCCcore-7.3.0/man:1;/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/man:1;/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/man:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/man:1;/apps/software/R/3.6.1-foss-2018b-bare/share/man:1;/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/share/man:1;/apps/software/gettext/0.20.1-GCCcore-7.3.0/share/man:1;/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/man:1;/apps/software/PCRE/8.43-GCCcore-7.3.0/share/man:1;/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/share/man:1;/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/share/man:1;/apps/software/NASM/2.13.03-GCCcore-7.3.0/share/man:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/share/man:1;/apps/software/ncurses/6.1-GCCcore-7.3.0/share/man:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/share/man:1;/apps/software/libpng/1.6.37-GCCcore-7.3.0/share/man:1;/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/man:1;/apps/software/SAMtools/1.9-foss-2018b/share/man:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/share/man:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/share/man:1;/apps/software/SQLite/3.29.0-GCCcore-7.3.0/share/man:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/share/man:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/man:1;/apps/software/libreadline/8.0-GCCcore-7.3.0/share/man:1;/apps/software/FFTW/3.3.8-gompi-2018b/share/man:1;/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/share/man:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/share/man:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/share/man:1;/apps/software/XZ/5.2.4-GCCcore-7.3.0/share/man:1;/apps/software/numactl/2.0.11-GCCcore-7.3.0/share/man:1;/apps/software/zlib/1.2.11-GCCcore-7.3.0/share/man:1;/apps/software/binutils/2.30-GCCcore-7.3.0/share/man:1;/apps/software/GCCcore/7.3.0/share/man:1
__LMOD_REF_COUNT_MODULEPATH = /apps/modules/vis:1;/apps/modules/tools:1;/apps/modules/toolchain:1;/apps/modules/system:1;/apps/modules/phys:1;/apps/modules/numlib:1;/apps/modules/mpi:1;/apps/modules/math:1;/apps/modules/lib:1;/apps/modules/lang:1;/apps/modules/devel:1;/apps/modules/data:1;/apps/modules/compiler:1;/apps/modules/bio:1
__LMOD_REF_COUNT_PATH = /apps/software/EasyBuild/3.9.3/bin:1;/apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/bin:1;/apps/software/CADD/v1.4-foss-2018b:1;/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/htslib:1;/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0:2;/apps/software/HTSlib/1.9-GCCcore-7.3.0/bin:1;/apps/software/cURL/7.63.0-GCCcore-7.3.0/bin:1;/apps/software/bzip2/1.0.6-GCCcore-7.3.0/bin:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/bin:1;/apps/software/R/3.6.1-foss-2018b-bare/bin:1;/apps/software/Pango/1.43.0-GCCcore-7.3.0/bin:1;/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/bin:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/bin:1;/apps/software/cairo/1.16.0-GCCcore-7.3.0/bin:1;/apps/software/GLib/2.61.1-GCCcore-7.3.0/bin:1;/apps/software/gettext/0.20.1-GCCcore-7.3.0/bin:1;/apps/software/AdoptOpenJDK/11.0.4_11-hotspot:1;/apps/software/AdoptOpenJDK/11.0.4_11-hotspot/bin:1;/apps/software/PCRE/8.43-GCCcore-7.3.0/bin:1;/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/bin:1;/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/bin:1;/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/bin:1;/apps/software/NASM/2.13.03-GCCcore-7.3.0/bin:1;/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/bin:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/sbin:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/bin:1;/apps/software/ncurses/6.1-GCCcore-7.3.0/bin:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/bin:1;/apps/software/libpng/1.6.37-GCCcore-7.3.0/bin:1;/apps/software/expat/2.2.7-GCCcore-7.3.0/bin:1;/apps/software/Perl/5.30.0-GCCcore-7.3.0-bare/bin:1;/apps/software/SAMtools/1.9-foss-2018b/bin:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/bin:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/bin:1;/apps/software/SQLite/3.29.0-GCCcore-7.3.0/bin:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/bin:1;/apps/software/libreadline/8.0-GCCcore-7.3.0/bin:1;/apps/software/FFTW/3.3.8-gompi-2018b/bin:1;/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/bin:1;/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/bin:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/sbin:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/bin:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/bin:1;/apps/software/XZ/5.2.4-GCCcore-7.3.0/bin:1;/apps/software/numactl/2.0.11-GCCcore-7.3.0/bin:1;/apps/software/binutils/2.30-GCCcore-7.3.0/bin:1;/apps/software/GCCcore/7.3.0/bin:1;/apps/software/lmod/lmod/libexec:2;/apps/software/Lua/5.1.4.9/bin:2;/usr/local/bin:1;/usr/bin:1;/usr/local/sbin:1;/usr/sbin:1;/home/umcg-gvdvries/.local/bin:1;/home/umcg-gvdvries/bin:1
__LMOD_REF_COUNT_PERL5LIB = /apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0:1;/apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0/x86_64-linux-thread-multi:1;/apps/software/BioPerl/1.7.2-foss-2018b-Perl-5.30.0:1;/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/modules:1;/apps/software/VEP/92.0-foss-2018b-Perl-5.30.0/modules/api:1;/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0:1;/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0/lib/perl5/site_perl/5.30.0/x86_64-linux-thread-multi:1;/apps/software/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0:1;/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib/perl5/site_perl/5.30.0:1;/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0/lib/perl5/site_perl/5.30.0/x86_64-linux-thread-multi:1;/apps/software/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib/perl5/site_perl/5.30.0:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib/perl5/site_perl:1;/apps/software/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1/lib/perl5:1
__LMOD_REF_COUNT_PKG_CONFIG_PATH = /apps/software/HTSlib/1.9-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/cURL/7.63.0-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/R/3.6.1-foss-2018b-bare/lib64/pkgconfig:1;/apps/software/Pango/1.43.0-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/FriBidi/1.0.5-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/cairo/1.16.0-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/GLib/2.61.1-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/pixman/0.38.4-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/PCRE/8.43-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/LibTIFF/4.0.10-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/libgd/2.2.5-GCCcore-7.3.0-lor/lib/pkgconfig:1;/apps/software/libjpeg-turbo/2.0.2-GCCcore-7.3.0/lib64/pkgconfig:1;/apps/software/fontconfig/2.13.1-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/util-linux/2.34-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/freetype/2.10.1-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/libpng/1.6.37-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/expat/2.2.7-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/lib/pkgconfig:1;/apps/software/libffi/3.2.1-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/SQLite/3.29.0-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/Tcl/8.6.9-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/libreadline/8.0-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/FFTW/3.3.8-gompi-2018b/lib/pkgconfig:1;/apps/software/OpenBLAS/0.3.1-GCC-7.3.0-2.30/lib/pkgconfig:1;/apps/software/OpenMPI/3.1.1-GCC-7.3.0-2.30/lib/pkgconfig:1;/apps/software/hwloc/1.11.10-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/libpciaccess/0.14-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/libxml2/2.9.8-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/XZ/5.2.4-GCCcore-7.3.0/lib/pkgconfig:1;/apps/software/zlib/1.2.11-GCCcore-7.3.0/lib/pkgconfig:1
__LMOD_REF_COUNT_PYTHONPATH = /apps/software/EasyBuild/3.9.3/lib/python2.7/site-packages:1;/apps/software/PythonPlus/2.7.16-foss-2018b-v20.02.1/lib/python2.7/site-packages:1;/apps/software/Python/2.7.16-GCCcore-7.3.0-bare/easybuild/python:1
__LMOD_REF_COUNT_XDG_DATA_DIRS = /apps/software/Pango/1.43.0-GCCcore-7.3.0/share:1;/apps/software/HarfBuzz/2.5.3-GCCcore-7.3.0/share:1
__LMOD_REF_COUNT__LMFILES_ = /apps/modules/compiler/GCCcore/7.3.0.lua:1;/apps/modules/tools/binutils/2.30-GCCcore-7.3.0.lua:1;/apps/modules/compiler/GCC/7.3.0-2.30.lua:1;/apps/modules/lib/zlib/1.2.11-GCCcore-7.3.0.lua:1;/apps/modules/tools/numactl/2.0.11-GCCcore-7.3.0.lua:1;/apps/modules/tools/XZ/5.2.4-GCCcore-7.3.0.lua:1;/apps/modules/lib/libxml2/2.9.8-GCCcore-7.3.0.lua:1;/apps/modules/system/libpciaccess/0.14-GCCcore-7.3.0.lua:1;/apps/modules/system/hwloc/1.11.10-GCCcore-7.3.0.lua:1;/apps/modules/mpi/OpenMPI/3.1.1-GCC-7.3.0-2.30.lua:1;/apps/modules/numlib/OpenBLAS/0.3.1-GCC-7.3.0-2.30.lua:1;/apps/modules/toolchain/gompi/2018b.lua:1;/apps/modules/numlib/FFTW/3.3.8-gompi-2018b.lua:1;/apps/modules/numlib/ScaLAPACK/2.0.2-gompi-2018b-OpenBLAS-0.3.1.lua:1;/apps/modules/toolchain/foss/2018b.lua:1;/apps/modules/lib/libreadline/8.0-GCCcore-7.3.0.lua:1;/apps/modules/lang/Tcl/8.6.9-GCCcore-7.3.0.lua:1;/apps/modules/devel/SQLite/3.29.0-GCCcore-7.3.0.lua:1;/apps/modules/math/GMP/6.1.2-GCCcore-7.3.0.lua:1;/apps/modules/lib/libffi/3.2.1-GCCcore-7.3.0.lua:1;/apps/modules/lang/Python/2.7.16-GCCcore-7.3.0-bare.lua:1;/apps/modules/lang/PythonPlus/2.7.16-foss-2018b-v20.02.1.lua:1;/apps/modules/bio/SAMtools/1.9-foss-2018b.lua:1;/apps/modules/lang/Perl/5.30.0-GCCcore-7.3.0-bare.lua:1;/apps/modules/tools/expat/2.2.7-GCCcore-7.3.0.lua:1;/apps/modules/lib/libpng/1.6.37-GCCcore-7.3.0.lua:1;/apps/modules/vis/freetype/2.10.1-GCCcore-7.3.0.lua:1;/apps/modules/devel/ncurses/6.1-GCCcore-7.3.0.lua:1;/apps/modules/tools/util-linux/2.34-GCCcore-7.3.0.lua:1;/apps/modules/vis/fontconfig/2.13.1-GCCcore-7.3.0.lua:1;/apps/modules/lang/NASM/2.13.03-GCCcore-7.3.0.lua:1;/apps/modules/lib/libjpeg-turbo/2.0.2-GCCcore-7.3.0.lua:1;/apps/modules/lib/libgd/2.2.5-GCCcore-7.3.0-lor.lua:1;/apps/modules/lib/LibTIFF/4.0.10-GCCcore-7.3.0.lua:1;/apps/modules/devel/PCRE/8.43-GCCcore-7.3.0.lua:1;/apps/modules/lang/AdoptOpenJDK/11.0.4_11-hotspot.lua:1;/apps/modules/lang/Java/11-LTS.lua:1;/apps/modules/vis/pixman/0.38.4-GCCcore-7.3.0.lua:1;/apps/modules/tools/gettext/0.20.1-GCCcore-7.3.0.lua:1;/apps/modules/vis/GLib/2.61.1-GCCcore-7.3.0.lua:1;/apps/modules/vis/cairo/1.16.0-GCCcore-7.3.0.lua:1;/apps/modules/vis/HarfBuzz/2.5.3-GCCcore-7.3.0.lua:1;/apps/modules/lang/FriBidi/1.0.5-GCCcore-7.3.0.lua:1;/apps/modules/vis/Pango/1.43.0-GCCcore-7.3.0.lua:1;/apps/modules/lang/R/3.6.1-foss-2018b-bare.lua:1;/apps/modules/lang/PerlPlus/5.30.0-GCCcore-7.3.0-v19.08.1.lua:1;/apps/modules/data/XML-LibXML/2.0132-GCCcore-7.3.0-Perl-5.30.0.lua:1;/apps/modules/bio/Bio-DB-HTS/2.11-foss-2018b-Perl-5.30.0.lua:1;/apps/modules/tools/bzip2/1.0.6-GCCcore-7.3.0.lua:1;/apps/modules/tools/cURL/7.63.0-GCCcore-7.3.0.lua:1;/apps/modules/bio/HTSlib/1.9-GCCcore-7.3.0.lua:1;/apps/modules/bio/VEP/92.0-foss-2018b-Perl-5.30.0.lua:1;/apps/modules/bio/CADD/v1.4-foss-2018b.lua:1;/apps/modules/bio/BioPerl/1.7.2-foss-2018b-Perl-5.30.0.lua:1;/apps/modules/tools/EasyBuild/3.9.3.lua:1
```