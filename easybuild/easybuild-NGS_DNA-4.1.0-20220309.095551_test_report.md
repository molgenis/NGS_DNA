#### Test result
Successfully built /apps/software/easyconfigs/easybuild-easyconfigs-2.8.50/easybuild/easyconfigs/n/NGS_DNA/NGS_DNA-4.1.0-foss-2018b.eb

#### Overview of tested easyconfigs (in order)
 * **SUCCESS** _NGS_DNA-4.1.0-foss-2018b.eb_ 

#### Time info
 * start: Wed, 09 Mar 2022 09:55:30 +0000 (UTC)
 * end: Wed, 09 Mar 2022 09:55:51 +0000 (UTC)

#### EasyBuild info
 * easybuild-framework version: 4.5.1
 * easybuild-easyblocks version: 4.5.1
 * command line:
```
eb --robot --robot-paths=/apps/software//easyconfigs/easybuild-easyconfigs-2.8.50/easybuild/easyconfigs//: /apps/software//easyconfigs/easybuild-easyconfigs-2.8.50/easybuild/easyconfigs//n/NGS_DNA/NGS_DNA-4.1.0-foss-2018b.eb
```
 * full configuration (includes defaults):
```
--accept-eula-for=''
--accept-eula=''
--allow-loaded-modules='EasyBuild'
--buildpath='/apps/.tmp/easybuild/builds/'
--check-ebroot-env-vars='warn'
--cleanup-builddir
--cleanup-easyconfigs
--cleanup-tmpdir
--color='auto'
--container-type='singularity'
--containerpath='/home/umcg-rkanninga/.local/easybuild/containers'
--default-opt-level='defaultopt'
--detect-loaded-modules='warn'
--disable-add-dummy-to-minimal-toolchains
--disable-add-system-to-minimal-toolchains
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
--disable-check-eb-deps
--disable-check-github
--disable-check-style
--disable-consider-archived-easyconfigs
--disable-container-build-image
--disable-containerize
--disable-copy-ec
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
--disable-fix-deprecated-easyconfigs
--disable-force
--disable-group-writable-installdir
--disable-hidden
--disable-ignore-checksums
--disable-ignore-index
--disable-ignore-locks
--disable-ignore-osdeps
--disable-ignore-test-failure
--disable-info
--disable-insecure-download
--disable-install-github-token
--disable-install-latest-eb-release
--disable-job
--disable-last-log
--disable-list-toolchains
--disable-logtostdout
--disable-missing-modules
--disable-module-depends-on
--disable-module-extensions
--disable-module-only
--disable-new-branch-github
--disable-new-pr
--disable-package
--disable-parallel-extensions-install
--disable-pretend
--disable-preview-pr
--disable-quiet
--disable-read-only-installdir
--disable-rebuild
--disable-recursive-module-unload
--disable-regtest
--disable-remove-ghost-install-dirs
--disable-rpath
--disable-sanity-check-only
--disable-sequential
--disable-set-default-module
--disable-show-config
--disable-show-default-configfiles
--disable-show-default-moduleclasses
--disable-show-ec
--disable-show-full-config
--disable-show-system-info
--disable-skip
--disable-skip-extensions
--disable-skip-test-cases
--disable-skip-test-step
--disable-sticky-bit
--disable-terse
--disable-trace
--disable-try-ignore-versionsuffixes
--disable-try-update-deps
--disable-unit-testing-mode
--disable-update-modules-tool-cache
--disable-upload-test-report
--disable-use-existing-modules
--enforce-checksums
--env-for-shebang='/usr/bin/env'
--envvars-user-modules='HOME'
--extended-dry-run-ignore-errors
--fixed-installdir-naming-scheme
--from-pr=''
--generate-devel-module
--ignore-dirs='.git,.svn'
--include-easyblocks-from-pr=''
--include-easyblocks=''
--include-module-naming-schemes=''
--include-toolchains=''
--index-max-age='604800'
--installpath='/apps'
--job-backend='GC3Pie'
--job-max-jobs='0'
--job-max-walltime='24'
--job-output-dir='/home/umcg-rkanninga'
--job-polling-interval='30.0'
--lib-lib64-symlink
--lib64-fallback-sanity-check
--lib64-lib-symlink
--local-var-naming-check='warn'
--logfile-format='easybuild,easybuild-%(name)s-%(version)s-%(date)s.%(time)s.log'
--map-toolchains
--max-fail-ratio-adjust-permissions='0.5'
--minimal-build-env='CC:gcc,CXX:g++'
--minimal-toolchains
--module-naming-scheme='EasyBuildMNS'
--module-syntax='Lua'
--moduleclasses='base,astro,bio,cae,chem,compiler,data,debugger,devel,geo,ide,lang,lib,math,mpi,numlib,perf,quantum,phys,system,toolchain,tools,vis'
--modules-tool-version-check
--modules-tool='Lmod'
--mpi-tests
--output-format='txt'
--output-style='auto'
--package-naming-scheme='EasyBuildPNS'
--package-release='1'
--package-tool-options=''
--package-tool='fpm'
--package-type='rpm'
--packagepath='/home/umcg-rkanninga/.local/easybuild/packages'
--pr-target-account='easybuilders'
--pr-target-branch='develop'
--pre-create-installdir
--repository='FileRepository'
--repositorypath='/home/umcg-rkanninga/.local/easybuild/ebfiles_repo'
--robot-paths='/apps/software//easyconfigs/easybuild-easyconfigs-2.8.50/easybuild/easyconfigs//:'
--robot='/apps/software//easyconfigs/easybuild-easyconfigs-2.8.50/easybuild/easyconfigs//:/apps/software/EasyBuild/4.5.1/easybuild/easyconfigs'
--set-gid-bit
--show-progress-bar
--sourcepath='/apps/sources/'
--strict='warn'
--subdir-modules='modules'
--subdir-software='software'
--suffix-modules-path='all'
--umask='002'
--use-ccache='False'
--use-f90cache='False'
--verify-easyconfig-filenames
--wait-on-lock-interval='60'
--wait-on-lock-limit='0'
````

#### System info
 * _core count:_ 4
 * _cpu arch:_ x86_64
 * _cpu arch name:_ UNKNOWN
 * _cpu model:_ AMD EPYC-Rome Processor
 * _cpu speed:_ 1996.25
 * _cpu vendor:_ AMD
 * _gcc version:_ Using built-in specs.; COLLECT_GCC=gcc; COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.5/lto-wrapper; Target: x86_64-redhat-linux; Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/cloog-install --enable-gnu-indirect-function --with-tune=generic --with-arch_32=x86-64 --build=x86_64-redhat-linux; Thread model: posix; gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) ; 
 * _glibc version:_ 2.17
 * _hostname:_ wh-dai
 * _os name:_ centos linux
 * _os type:_ Linux
 * _os version:_ 7.9.2009
 * _platform name:_ x86_64-unknown-linux
 * _python version:_ 2.7.5 (default, Nov 16 2020, 22:23:17) ; [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]
 * _system gcc path:_ /usr/bin/gcc
 * _system python path:_ /usr/bin/python
 * _total memory:_ 7820

#### List of loaded modules
 * EasyBuild/4.5.1

#### Environment
```
BASH_FUNC_ml() = () {  eval $($LMOD_DIR/ml_cmd "$@")
}
BASH_FUNC_module() = () {  eval $($LMOD_CMD bash "$@") && eval $(${LMOD_SETTARG_CMD:-:} -s sh)
}
CMAKE_PREFIX_PATH = /apps/software/EasyBuild/4.5.1
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
EBDEVELEASYBUILD = /apps/software/EasyBuild/4.5.1/easybuild/EasyBuild-4.5.1-easybuild-devel
EBROOTEASYBUILD = /apps/software//EasyBuild/4.5.1
EBVERSIONEASYBUILD = 4.5.1
EB_SCRIPT_PATH = /apps/software/EasyBuild/4.5.1/bin/eb
FANCYLOGGER_IGNORE_MPI4PY = 1
FPATH = /apps/software/lmod/lmod/init/ksh_funcs
HOME = /home/umcg-rkanninga
HPC_ENV_PREFIX = /apps
LANG = en_US.UTF-8
LESSOPEN = ||/usr/bin/lesspipe.sh %s
LMOD_ADMIN_FILE = /apps/modules/modules.admin
LMOD_CACHE_DIR = /apps/modules/.lmod/cache/
LMOD_CASE_INDEPENDENT_SORTING = True
LMOD_CMD = /apps/software/lmod/lmod/libexec/lmod
LMOD_DIR = /apps/software/lmod/lmod/libexec
LMOD_PAGER = none
LMOD_PKG = /apps/software/lmod/lmod
LMOD_RC = /apps/modules/.lmod/lmodrc.lua
LMOD_REDIRECT = True
LMOD_ROOT = /apps/software/lmod
LMOD_SETTARG_FULL_SUPPORT = no
LMOD_TIMESTAMP_FILE = /apps/modules/.lmod/modules_changed.timestamp
LMOD_VERSION = 8.6.2
LOADEDMODULES = EasyBuild/4.5.1
LOGNAME = umcg-rkanninga
LS_COLORS = rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:
MAIL = /var/mail/umcg-rkanninga
MODULEPATH = /apps/modules/vis:/apps/modules/tools:/apps/modules/toolchain:/apps/modules/system:/apps/modules/numlib:/apps/modules/mpi:/apps/modules/math:/apps/modules/lib:/apps/modules/lang:/apps/modules/devel:/apps/modules/data:/apps/modules/compiler:/apps/modules/bio
MODULESHOME = /apps/software/lmod/lmod
PATH = /apps/software/EasyBuild/4.5.1/bin:/apps/software/lmod/lmod/libexec:/apps/software/Lua/5.1.4.9/bin:/usr/local/bin:/usr/bin
PWD = /home/umcg-rkanninga
PYTHONOPTIMIZE = 1
PYTHONPATH = /apps/software/EasyBuild/4.5.1/lib/python3.6/site-packages
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
SHLVL = 4
SOURCE_HPC_ENV = True
SSH_AUTH_SOCK = /tmp/ssh-l9nz8aoG5v/agent.21037
SSH_CLIENT = 10.10.1.148 39946 22
SSH_CONNECTION = 10.10.1.148 39946 10.10.1.155 22
SSH_TTY = /dev/pts/1
TERM = xterm-256color
TEST_EASYBUILD_MODULES_TOOL = Lmod
USER = umcg-rkanninga
_ = /usr/bin/python
_LMFILES_ = /apps/modules/tools/EasyBuild/4.5.1.lua
_ModuleTable001_ = X01vZHVsZVRhYmxlXyA9IHsKTVR2ZXJzaW9uID0gMywKY19yZWJ1aWxkVGltZSA9IGZhbHNlLApjX3Nob3J0VGltZSA9IGZhbHNlLApkZXB0aFQgPSB7fSwKZmFtaWx5ID0ge30sCm1UID0gewpFYXN5QnVpbGQgPSB7CmZuID0gIi9hcHBzL21vZHVsZXMvdG9vbHMvRWFzeUJ1aWxkLzQuNS4xLmx1YSIsCmZ1bGxOYW1lID0gIkVhc3lCdWlsZC80LjUuMSIsCmxvYWRPcmRlciA9IDEsCnByb3BUID0ge30sCnN0YWNrRGVwdGggPSAwLApzdGF0dXMgPSAiYWN0aXZlIiwKdXNlck5hbWUgPSAiRWFzeUJ1aWxkLzQuNS4xIiwKd1YgPSAiMDAwMDAwMDA0LjAwMDAwMDAwNS4wMDAwMDAwMDEuKnpmaW5hbCIsCn0sCn0sCm1wYXRoQSA9IHsKIi9hcHBzL21vZHVsZXMvdmlzIgosICIvYXBw
_ModuleTable002_ = cy9tb2R1bGVzL3Rvb2xzIgosICIvYXBwcy9tb2R1bGVzL3Rvb2xjaGFpbiIKLCAiL2FwcHMvbW9kdWxlcy9zeXN0ZW0iCiwgIi9hcHBzL21vZHVsZXMvbnVtbGliIgosICIvYXBwcy9tb2R1bGVzL21waSIKLCAiL2FwcHMvbW9kdWxlcy9tYXRoIgosICIvYXBwcy9tb2R1bGVzL2xpYiIKLCAiL2FwcHMvbW9kdWxlcy9sYW5nIgosICIvYXBwcy9tb2R1bGVzL2RldmVsIgosICIvYXBwcy9tb2R1bGVzL2RhdGEiCiwgIi9hcHBzL21vZHVsZXMvY29tcGlsZXIiLCAiL2FwcHMvbW9kdWxlcy9iaW8iLAp9LAp9Cg==
_ModuleTable_Sz_ = 2
__LMOD_REF_COUNT_CMAKE_PREFIX_PATH = /apps/software/EasyBuild/4.5.1:1
__LMOD_REF_COUNT_LOADEDMODULES = EasyBuild/4.5.1:1
__LMOD_REF_COUNT_MODULEPATH = /apps/modules/vis:1;/apps/modules/tools:1;/apps/modules/toolchain:1;/apps/modules/system:1;/apps/modules/numlib:1;/apps/modules/mpi:1;/apps/modules/math:1;/apps/modules/lib:1;/apps/modules/lang:1;/apps/modules/devel:1;/apps/modules/data:1;/apps/modules/compiler:1;/apps/modules/bio:1
__LMOD_REF_COUNT_PATH = /apps/software/EasyBuild/4.5.1/bin:1;/apps/software/lmod/lmod/libexec:2;/apps/software/Lua/5.1.4.9/bin:2;/usr/local/bin:1;/usr/bin:1
__LMOD_REF_COUNT_PYTHONPATH = /apps/software/EasyBuild/4.5.1/lib/python3.6/site-packages:1
__LMOD_REF_COUNT__LMFILES_ = /apps/modules/tools/EasyBuild/4.5.1.lua:1
__LMOD_SET_FPATH = 1
```