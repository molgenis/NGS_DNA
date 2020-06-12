# Latest release Genetics diagnostics department UMCG 

## Is in use since 13-03-2020 (March 13 2020)

download here: https://github.com/molgenis/NGS_DNA/releases/tag/3.5.6

## Release notes 3.5.6 (and 3.5.4):
### 3.5.6
- number of rows in samplesheet > 200 is not producing an error anymore
- XT-HS bugfix in CoverageCalculations

### 3.5.4
######updates:
- requesting resources for a protocol is now handled via a parameters file (bigger datasets sometimes require more resources). all #MOLGENIS headers are removed from the protocols. This can now be used with the new Molgenis-Compute (see below)
- reads with a mapping quality below 20 will not be used in calculating coverage
- new Molgenis-Compute-19.01.1-Java-11.0.2 version (before: Molgenis-Compute-17.08.1-Java-1.8.0_74)
######bugfixes:
- (diagnostics) fixing ONCO_v5 issue. The pipeline will execute genderCheck automatically when there is chrX available. ONCO_v5 has only a very small percentage of targets on chrX which is not reliable enough. fix: when ONCO, no GenderCheck
- rejected samples (due to no or 0.0% reads for a barcode) were not removed from the samplesheet.
- Gavin bugfix: when choosing option BOTH the merged INFO fields will be pasted directly to the other INFO fields without a separator, this is now fixed (with perl replace command)

