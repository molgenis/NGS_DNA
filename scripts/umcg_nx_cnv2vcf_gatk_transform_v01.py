import argparse
import csv
import gzip
from contextlib import contextmanager
from datetime import datetime
import sys
import pysam


SAMPLE_DATA_FIELDS = ["GT", "CN", "BC"]
"""
Input Fields 
#Genomebuild = GRCh37
#Sample = 19971411_2483215_DNA183642_752706_GS382B_2874308_V
Chromosome Region
chr1:12.850.310-12.902.810
Length
52501
Event 
Homozygous Copy Loss CN:0,GT 1/1
CN Loss CN:1 GT 0/1
CN Gain CN:3 ./1
High Copy Gain CN:4 ./1
"""


@contextmanager
def open_file(filename, mode="r"):
    if "t" not in mode:
        mode += "t"
        _open = gzip.open if filename.endswith(".gz") else open
        with _open(filename, mode, encoding="utf-8") as f:
            yield f


def parse_arguments():
    argument_parser = argparse.ArgumentParser()
    parser = argument_parser.add_argument_group("Required arguments:")
    parser.add_argument(
        "-i", help="Input file NxClinical or GATK vcf.gz", required=True
    )
    # parser.add_argument(
    #     "-o",
    #     dest="output_path",
    #     required=True,
    #     help="output file containing both CNVs and SNVs in VCF format",
    # )
    return argument_parser.parse_args()


def filter_bgzip_vcf(input_vcf_gz, output_vcf_gz, filter_string):
    # Open the input bgzip-compressed VCF file
    with pysam.BGZFile(input_vcf_gz, "r") as infile, pysam.BGZFile(
        output_vcf_gz, "w"
    ) as outfile:
        for line in infile:
            decoded_line = line.decode("utf-8").rstrip("\n")
            if filter_string not in decoded_line:
                outfile.write((decoded_line + "\n").encode("utf-8"))
            else:
                print(decoded_line)


def validate_bgzip_file(file_path):
    try:
        # Attempt to open the file in read mode.
        # This will raise an exception if the file is not a valid bgzip file.
        with pysam.BGZFile(file_path, "r") as infile:
            # We don't need to read the whole file, just checking that we can
            # iterate over it without errors is a good validation step.
            for line in infile:
                test = True
        print(f"Validation successful: '{file_path}' is a valid bgzip file.")
        return True
    except Exception as e:
        # If any exception occurs (e.g., file not found, bad format),
        # we catch it and report a failure.
        print(f"Validation failed for '{file_path}': {e}")
        return False


def main():
    args = parse_arguments()

    if str(args.i).endswith("vcf.gz"):
        print("GATK vcf.gz file found")
        input_file = args.i
        # input_file = "20253226_0000000_DNA186116_763028_MAGR653A_AllExonV7_755443_2983668.merged.variant.calls.g.vcf.gz"
        file_split = input_file.split(".")
        sample_name = file_split[0]
        print(sample_name)
        string_to_filter = "NC_001422.1"
        output_file = sample_name + "_mod.vcf.gz"
        filter_lines_bgzip = filter_bgzip_vcf(input_file, output_file, string_to_filter)
        is_valid = validate_bgzip_file(output_file)
    elif str(args.i).endswith(".txt"):
        print("NxClinical TXT file found")
        with open_file(args.i) as input_cnv_file:
            lines = list(input_cnv_file)
            sample_lines = (line for line in lines if line.startswith("#Sample"))
            sample_reader = csv.DictReader(sample_lines, delimiter="\t")
            for item in sample_reader:
                keys = item.keys()
                for key in keys:
                    sample_id = key[10:]

            output_path = sample_id + "_NxC.vcf"
            with open_file(output_path, "w") as output_file:
                current_date = datetime.now().strftime("%Y%m%d")
                headers = [
                    "##fileformat=VCFv4.1",
                    f"##fileDate={current_date}",
                    "##reference=file:///staging/human/reference/grch37",
                    '##DRAGENVersion=<ID=dragen,Version="SW: 05.121.732.4.3.13, HW: 05.121.732">',
                    "##DRAGENCommandLine=<ID=dragen>",
                    "##source=DRAGEN_CNV",
                    f'##ALT=<ID=DEL,Description="Deletion">',
                    f'##ALT=<ID=DUP,Description="Duplication">',
                    f'##ALT=<ID=CNV,Description="Copy number variant region">',
                    "##contig=<ID=chr1,length=249250621>",
                    "##contig=<ID=chr2,length=243199373>",
                    "##contig=<ID=chr3,length=198022430>",
                    "##contig=<ID=chr4,length=191154276>",
                    "##contig=<ID=chr5,length=180915260>",
                    "##contig=<ID=chr6,length=171115067>",
                    "##contig=<ID=chr7,length=159138663>",
                    "##contig=<ID=chr8,length=146364022>",
                    "##contig=<ID=chr9,length=141213431>",
                    "##contig=<ID=chr10,length=135534747>",
                    "##contig=<ID=chr11,length=135006516>",
                    "##contig=<ID=chr12,length=133851895>",
                    "##contig=<ID=chr13,length=115169878>",
                    "##contig=<ID=chr14,length=107349540>",
                    "##contig=<ID=chr15,length=102531392>",
                    "##contig=<ID=chr16,length=90354753>",
                    "##contig=<ID=chr17,length=81195210>",
                    "##contig=<ID=chr18,length=78077248>",
                    "##contig=<ID=chr19,length=59128983>",
                    "##contig=<ID=chr20,length=63025520>",
                    "##contig=<ID=chr21,length=48129895>",
                    "##contig=<ID=chr22,length=51304566>",
                    "##contig=<ID=chrX,length=155270560>",
                    "##contig=<ID=chrY,length=59373566>",
                    f'##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype fixed values based on NxClinical Event">',
                    f'##FORMAT=<ID=CN,Number=1,Type=String,Description="Copy Number Estimate fixed values based on NxClinical Event">',
                    f'##FORMAT=<ID=BC,Number=1,Type=String,Description="Bin Count represents number of NxClinical Probes">',
                    f'##INFO=<ID=SVLEN,Number=1,Type=Integer,Description="Length of the SV">',
                    f'##INFO=<ID=END,Number=1,Type=Integer,Description="End position of the structural variant">',
                    f'##INFO=<ID=MOSAIC,Number=1,Type=Integer,Description="Mosaic Field from NxClinical text file">',
                ]
                for header in headers:
                    output_file.write(header + "\n")
                vcf_headers = [
                    "#CHROM",
                    "POS",
                    "ID",
                    "REF",
                    "ALT",
                    "QUAL",
                    "FILTER",
                    "INFO",
                    "FORMAT",
                    sample_id,
                ]
                output_file.write("\t".join(vcf_headers) + "\n")
                variant_lines = (line for line in lines if not line.startswith("#"))
                cnv_reader = csv.DictReader(variant_lines, delimiter="\t")
                for cnv_line in cnv_reader:
                    chrposition = cnv_line["Chromosome Region"]
                    chromosome = chrposition.split(":")[0]
                    print(chromosome)
                    start_pos = chrposition.split(":")[1].split("-")[0].replace(".", "")
                    end_pos = chrposition.split(":")[1].split("-")[1].replace(".", "")
                    print(start_pos + ":" + end_pos)
                    ref = "N"
                    alt = "."
                    qual = 31
                    FITLER = "PASS"
                    print(cnv_line["Event"])
                    if cnv_line["Event"] == "Homozygous Copy Loss":
                        SVTYPE = "DEL"
                        CN = 0
                        GT = "1/1"
                    elif cnv_line["Event"] == "CN Loss":
                        SVTYPE = "DEL"
                        CN = 1
                        GT = "0/1"
                    elif cnv_line["Event"] == "CN Gain":
                        SVTYPE = "DUP"
                        CN = 3
                        GT = "./1"
                    elif cnv_line["Event"] == "High Copy Gain":
                        SVTYPE = "DUP"
                        CN = 4
                        GT = "./1"
                    BC = cnv_line["No of Probes"]
                    END = end_pos
                    SVLEN = int(end_pos) - int(start_pos)
                    REFLEN = abs(int(end_pos) - int(start_pos))
                    ref_allele = "N"
                    mosaic = cnv_line["Mosaic"]
                    if mosaic == "":
                        mosaic = 0
                    else:
                        print(mosaic)
                    info_dict = {
                        "SVTYPE": SVTYPE,
                        "REFLEN": REFLEN,
                        "SVLEN": SVLEN,
                        "END": END,
                        "MOSAIC": mosaic,
                    }
                    info_field = ";".join(
                        [f"{key}={value}" for key, value in info_dict.items()]
                    )

                    # # chr, pos, id, ref, alt, qual, filter, info, format, *samples
                    vcf_fields = [
                        chromosome,
                        start_pos,
                        f"{chromosome}:{start_pos}-{END}_{SVTYPE}",
                        ref_allele,
                        f"<{SVTYPE}>",
                        str(qual),
                        "PASS",
                        info_field,
                        ":".join(SAMPLE_DATA_FIELDS),
                        ":".join([GT, str(CN), str(BC)]),
                    ]
                    output_file.write("\t".join(vcf_fields) + "\n")
    else:
        print("Neither filetype found")


if __name__ == "__main__":
    main()
