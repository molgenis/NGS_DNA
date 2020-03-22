#### Test result
Successfully built /home/umcg-rkanninga/github/easybuild-easyconfigs/easybuild/easyconfigs/n/NGS_DNA/NGS_DNA-4.0.1-foss-2018b.eb

#### Overview of tested easyconfigs (in order)
 * **SUCCESS** _NGS_DNA-4.0.1-foss-2018b.eb_ 

#### Time info
 * start: Thu, 31 Oct 2019 15:28:04 +0000 (UTC)
 * end: Thu, 31 Oct 2019 15:28:17 +0000 (UTC)

#### EasyBuild info
 * easybuild-framework version: 3.9.3
 * easybuild-easyblocks version: 3.9.3
 * command line:
```
eb -f NGS_DNA-4.0.1-foss-2018b.eb --robot --robot-paths=/home/umcg-rkanninga/github/easybuild-easyconfigs/easybuild/easyconfigs
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
--containerpath='/home/umcg-rkanninga/.local/easybuild/containers'
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
--force
--ignore-dirs='.git,.svn'
--include-easyblocks=''
--include-module-naming-schemes=''
--include-toolchains=''
--installpath='/apps'
--job-backend='GC3Pie'
--job-max-jobs='0'
--job-max-walltime='24'
--job-output-dir='/home/umcg-rkanninga/github/easybuild-easyconfigs/easybuild/easyconfigs/n/NGS_DNA'
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
--packagepath='/home/umcg-rkanninga/.local/easybuild/packages'
--pr-target-account='easybuilders'
--pr-target-branch='develop'
--pr-target-repo='easybuild-easyconfigs'
--pre-create-installdir
--repository='FileRepository'
--repositorypath='/home/umcg-rkanninga/.local/easybuild/ebfiles_repo'
--robot-paths='/home/umcg-rkanninga/github/easybuild-easyconfigs/easybuild/easyconfigs'
--robot='/home/umcg-rkanninga/github/easybuild-easyconfigs/easybuild/easyconfigs'
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
 * _gcc version:_ Using built-in specs.; COLLECT_GCC=gcc; COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.5/lto-wrapper; Target: x86_64-redhat-linux; Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/cloog-install --enable-gnu-indirect-function --with-tune=generic --with-arch_32=x86-64 --build=x86_64-redhat-linux; Thread model: posix; gcc version 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) ; 
 * _glibc version:_ 2.17
 * _hostname:_ sugarsnax
 * _os name:_ centos linux
 * _os type:_ Linux
 * _os version:_ 7.6.1810
 * _platform name:_ x86_64-unknown-linux
 * _python version:_ 2.7.5 (default, Oct 30 2018, 23:45:53) ; [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
 * _system gcc path:_ /usr/bin/gcc
 * _system python path:_ /usr/bin/python
 * _total memory:_ 3789

#### List of loaded modules
 * EasyBuild/3.9.3

#### Environment
```
BASH_FUNC_ml() = () {  eval $($LMOD_DIR/ml_cmd "$@")
}
BASH_FUNC_module() = () {  eval $($LMOD_CMD bash "$@") && eval $(${LMOD_SETTARG_CMD:-:} -s sh)
}
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
EBDEVELEASYBUILD = /apps/software/EasyBuild/3.9.3/easybuild/EasyBuild-3.9.3-easybuild-devel
EBROOTEASYBUILD = /apps/software/EasyBuild/3.9.3
EBVERSIONEASYBUILD = 3.9.3
FANCYLOGGER_IGNORE_MPI4PY = 1
HISTCONTROL = ignoredups
HISTSIZE = 1000
HOME = /home/umcg-rkanninga
HOSTNAME = sugarsnax
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
LMOD_SETTARG_FULL_SUPPORT = no
LMOD_TIMESTAMP_FILE = /apps/modules/.lmod/modules_changed.timestamp
LMOD_VERSION = 7.8.8
LOADEDMODULES = EasyBuild/3.9.3
LOGNAME = umcg-rkanninga
LS_COLORS = rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:
MAIL = /var/spool/mail/umcg-rkanninga
MODULEPATH = /groups/umcg-gaf/tmp04/rkanninga/modules:/apps/modules/vis:/apps/modules/tools:/apps/modules/toolchain:/apps/modules/system:/apps/modules/phys:/apps/modules/numlib:/apps/modules/mpi:/apps/modules/math:/apps/modules/lib:/apps/modules/lang:/apps/modules/devel:/apps/modules/compiler:/apps/modules/bio
MODULESHOME = /apps/software/lmod/lmod
PATH = /apps/software/EasyBuild/3.9.3/bin:/apps/software/lmod/lmod/libexec:/apps/software/Lua/5.1.4.9/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/umcg-rkanninga/.local/bin:/home/umcg-rkanninga/bin
PWD = /home/umcg-rkanninga/github/easybuild-easyconfigs/easybuild/easyconfigs/n/NGS_DNA
PYTHONOPTIMIZE = 1
PYTHONPATH = /apps/software/EasyBuild/3.9.3/lib/python2.7/site-packages
ROAN_GCC_HOME = /gcc/groups/gcc/tmp01/rkanninga/
ROAN_HOME = /gcc/groups/gcc/home/rkanninga
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
SHLVL = 3
SSH_CLIENT = 172.23.40.33 55196 22
SSH_CONNECTION = 172.23.40.33 55196 172.23.40.35 22
SSH_TTY = /dev/pts/0
STY = 18210.pts-0.sugarsnax
TERM = screen
TERMCAP = SC|screen|VT 100/ANSI X3.64 virtual terminal:\
	:DO=\E[%dB:LE=\E[%dD:RI=\E[%dC:UP=\E[%dA:bs:bt=\E[Z:\
	:cd=\E[J:ce=\E[K:cl=\E[H\E[J:cm=\E[%i%d;%dH:ct=\E[3g:\
	:do=^J:nd=\E[C:pt:rc=\E8:rs=\Ec:sc=\E7:st=\EH:up=\EM:\
	:le=^H:bl=^G:cr=^M:it#8:ho=\E[H:nw=\EE:ta=^I:is=\E)0:\
	:li#81:co#268:am:xn:xv:LP:sr=\EM:al=\E[L:AL=\E[%dL:\
	:cs=\E[%i%d;%dr:dl=\E[M:DL=\E[%dM:dc=\E[P:DC=\E[%dP:\
	:im=\E[4h:ei=\E[4l:mi:IC=\E[%d@:ks=\E[?1h\E=:\
	:ke=\E[?1l\E>:vi=\E[?25l:ve=\E[34h\E[?25h:vs=\E[34l:\
	:ti=\E[?1049h:te=\E[?1049l:us=\E[4m:ue=\E[24m:so=\E[3m:\
	:se=\E[23m:mb=\E[5m:md=\E[1m:mr=\E[7m:me=\E[m:ms:\
	:Co#8:pa#64:AF=\E[3%dm:AB=\E[4%dm:op=\E[39;49m:AX:\
	:vb=\Eg:G0:as=\E(0:ae=\E(B:\
	:ac=\140\140aaffggjjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~..--++,,hhII00:\
	:po=\E[5i:pf=\E[4i:Km=\E[M:k0=\E[10~:k1=\EOP:k2=\EOQ:\
	:k3=\EOR:k4=\EOS:k5=\E[15~:k6=\E[17~:k7=\E[18~:\
	:k8=\E[19~:k9=\E[20~:k;=\E[21~:F1=\E[23~:F2=\E[24~:\
	:F3=\E[1;2P:F4=\E[1;2Q:F5=\E[1;2R:F6=\E[1;2S:\
	:F7=\E[15;2~:F8=\E[17;2~:F9=\E[18;2~:FA=\E[19;2~:kb=:\
	:K2=\EOE:kB=\E[Z:kF=\E[1;2B:kR=\E[1;2A:*4=\E[3;2~:\
	:*7=\E[1;2F:#2=\E[1;2H:#3=\E[2;2~:#4=\E[1;2D:%c=\E[6;2~:\
	:%e=\E[5;2~:%i=\E[1;2C:kh=\E[1~:@1=\E[1~:kH=\E[4~:\
	:@7=\E[4~:kN=\E[6~:kP=\E[5~:kI=\E[2~:kD=\E[3~:ku=\EOA:\
	:kd=\EOB:kr=\EOC:kl=\EOD:km:
TEST_EASYBUILD_MODULES_TOOL = Lmod
USER = umcg-rkanninga
WINDOW = 0
_ = /usr/bin/python2
_LMFILES_ = /apps/modules/tools/EasyBuild/3.9.3.lua
_ModuleTable001_ = X01vZHVsZVRhYmxlXz17WyJNVHZlcnNpb24iXT0zLFsiY19yZWJ1aWxkVGltZSJdPWZhbHNlLFsiY19zaG9ydFRpbWUiXT1mYWxzZSxkZXB0aFQ9e30sZmFtaWx5PXt9LG1UPXtFYXN5QnVpbGQ9e1siZm4iXT0iL2FwcHMvbW9kdWxlcy90b29scy9FYXN5QnVpbGQvMy45LjMubHVhIixbImZ1bGxOYW1lIl09IkVhc3lCdWlsZC8zLjkuMyIsWyJsb2FkT3JkZXIiXT0xLHByb3BUPXt9LFsic3RhY2tEZXB0aCJdPTAsWyJzdGF0dXMiXT0iYWN0aXZlIixbInVzZXJOYW1lIl09IkVhc3lCdWlsZCIsfSx9LG1wYXRoQT17Ii9ncm91cHMvdW1jZy1nYWYvdG1wMDQvcmthbm5pbmdhL21vZHVsZXMiLCIvYXBwcy9tb2R1bGVzL3ZpcyIsIi9hcHBzL21vZHVsZXMvdG9vbHMiLCIvYXBwcy9t
_ModuleTable002_ = b2R1bGVzL3Rvb2xjaGFpbiIsIi9hcHBzL21vZHVsZXMvc3lzdGVtIiwiL2FwcHMvbW9kdWxlcy9waHlzIiwiL2FwcHMvbW9kdWxlcy9udW1saWIiLCIvYXBwcy9tb2R1bGVzL21waSIsIi9hcHBzL21vZHVsZXMvbWF0aCIsIi9hcHBzL21vZHVsZXMvbGliIiwiL2FwcHMvbW9kdWxlcy9sYW5nIiwiL2FwcHMvbW9kdWxlcy9kZXZlbCIsIi9hcHBzL21vZHVsZXMvY29tcGlsZXIiLCIvYXBwcy9tb2R1bGVzL2JpbyIsfSx9
_ModuleTable_Sz_ = 2
__LMOD_REF_COUNT_LOADEDMODULES = EasyBuild/3.9.3:1
__LMOD_REF_COUNT_MODULEPATH = /groups/umcg-gaf/tmp04/rkanninga/modules:1;/apps/modules/vis:1;/apps/modules/tools:1;/apps/modules/toolchain:1;/apps/modules/system:1;/apps/modules/phys:1;/apps/modules/numlib:1;/apps/modules/mpi:1;/apps/modules/math:1;/apps/modules/lib:1;/apps/modules/lang:1;/apps/modules/devel:1;/apps/modules/compiler:1;/apps/modules/bio:1
__LMOD_REF_COUNT_PATH = /apps/software/EasyBuild/3.9.3/bin:1;/apps/software/lmod/lmod/libexec:2;/apps/software/Lua/5.1.4.9/bin:2;/usr/local/bin:1;/usr/bin:1;/usr/local/sbin:1;/usr/sbin:1;/home/umcg-rkanninga/.local/bin:1;/home/umcg-rkanninga/bin:1
__LMOD_REF_COUNT_PYTHONPATH = /apps/software/EasyBuild/3.9.3/lib/python2.7/site-packages:1
__LMOD_REF_COUNT__LMFILES_ = /apps/modules/tools/EasyBuild/3.9.3.lua:1
```