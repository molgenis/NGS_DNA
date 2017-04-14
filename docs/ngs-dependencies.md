### 1) Dependency tree
```
- BWA (0.7.15)
- sambamba (v0.6.6)
- io_lib (1.14.6)
- Python (2.7.10)
- Zlib (1.2.8)
- bzip2 (1.0.6)
- libreadline (6.3)
	o ncursus (5.9)
- Picard
	o R(3.3.1)
		• libreadline (6.3)
		• ncursus (5.9)
		• libjpeg-turbo (1.4.2)
		• NASM(2.11.08)
		• LibTIFF (4.0.4)
		• Tk (8.6.4)
			o Tcl (8.6.4.) 
				• Zlib (1.2.8)
		• cUrl (7.47.1)
		• libxml2 (2.9.2)
		• cairo (1.14.6)
			o bzip2 (1.0.6)
			o pixman (0.32.8)
			o fontconfig (2.11.94)
				• freetype (2.6.1)
					o libpng (1.6.21)
						• zlib (1.2.8)
					o expat (2.1.0)
		• PCRE (8.38)
		• Java (1.8.0_45)
	o Java (1.7.0_80)
- HTSLib (1.3.2)
- cutadapt (1.9.1)
- wkhtmltox (0.12.3)
- ngs-utils (16.12.1)
	o Text-CSV (1.33)
	o Log-Log4Perl (1.46)
- Molgenis-Compute (16.08.1)
- CmdLineAnnotator (1.9.0)
```

### 2) NGS_DNA-3.4.0 pipeline dependencies
```
('BWA', '0.7.12', '', ('foss', '2015b')),
('BEDTools', '2.25.0', '', ('foss', '2015b')),
('CoNVaDING', '1.1.6', '', ('dummy', '')),
('Molgenis-Compute', 'v16.08.1', '-Java-1.8.0_74'),
('FastQC', '0.11.3', '-Java-1.7.0_80'),
('GATK', '3.7', '-Java-1.8.0_74'),
('Gavin-ToolPack', '1.0', '-Java-1.8.0_74'),
('io_lib', '1.14.6', '', ('foss', '2015b')),
('manta','1.0.1', '', ('foss', '2015b')),
('snpEff', '4.3', '-Java-1.7.0_80'),
('ngs-utils', '16.12.1', '', ('dummy', '')),
('pigz', '2.3.1', '', ('foss', '2015b')),
('picard', '2.9.0', '-Java-1.8.0_74'),
('sambamba', 'v0.6.6', '', ('foss', '2015b')),
('seqtk', '1.2', '', ('foss', '2015b')),
('SAMtools', '1.2', '', ('foss', '2015b')),
('HTSlib', '1.3.2', '', ('foss', '2015b')),
('CmdLineAnnotator', '1.21.1', '-Java-1.8.0_45'),
('wkhtmltox', '0.12.3', '', ('dummy', '')),
('xhmm', '2016-01-04-cc14e528d909', '', ('foss', '2015b'))
```
