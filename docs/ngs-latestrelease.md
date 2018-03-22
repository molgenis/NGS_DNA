# Latest release

download here: https://github.com/molgenis/NGS_DNA/releases/tag/3.4.4

## Release notes 3.4.4:

** updated docs **

** updated **
- changed prm/cluster for diagnostics 
- decreased resources used in some protocols
- removed unused workflows (gonl/hmf)

** bugfixes **
- CopyToResultsDir: copying rejectedSamples => misplaced quote
- removed FIFO pipe in prepareFastQ step since this sometimes occurs in an error
