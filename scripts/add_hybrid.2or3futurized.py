
from __future__ import with_statement
from __future__ import absolute_import
from __future__ import print_function
from builtins import str
from io import open


import yaml


def read_sample_info(sample_yaml):
    # with open("C:/Users/tyler/repos/NGS_DNA/prometheus.sample_info.yaml", "r") as infile:
    with open(sample_yaml) as infile:
        sample = yaml.safe_load(infile)

    if isinstance(sample[u"lanes"], str):
        sample[u"lanes"] = sample[u"lanes"].split(u",")
    sample[u"external_fastq_1"] = trim_external_fastq(sample[u"external_fastq_1"])
    sample[u"external_fastq_2"] = trim_external_fastq(sample[u"external_fastq_2"])

    return sample

def read_samplesheet(samplesheet_csv):
    with open(samplesheet_csv) as infile:
        header = infile.readline()
        body = infile.readlines()
    header = header.strip().split(u",")
    body = [line.strip().split(u",") for line in body]
    return header, body

def read_alt_mappings(alt_map_yaml):
    with open(alt_map_yaml) as infile:
        alt_map = yaml.safe_load(infile)
    alt_map = {v.lower(): k for k, vlist in list(alt_map.items()) for v in vlist}
    return alt_map

def get_project(header, sample_sheet):
    line_dicts = []
    for line in sample_sheet:
        line_dicts.append(dict(zip(header, line)))
    projects = set([line_dict[u"project"] for line_dict in line_dicts])
    if len(projects) > 1:
        print(u"Warning: Multiple projects found: {}".format(projects))
    return list(projects)[0]

def trim_external_fastq(ex_fq):
    if isinstance(ex_fq, list):
        trimmed = [fq for fq in ex_fq if fq is not None]
    if trimmed:
        return trimmed
    return None

def check_barcodes(sample):
    if sample[u"barcode1"] is None or u"-" not in sample[u"barcode1"]:
        return
    barcode1 = sample[u"barcode1"].split(u"-")[0]
    barcode2 = sample[u"barcode1"].split(u"-")[1]
    if sample[u"barcode2"] is not None and sample[u"barcode2"] != barcode2:
        print (u"Warning: Barcode error.\n"
              + u"Barcode1: {}\n".format(sample[u'barcode1'])
              + u"Barcode2: {}".format(sample[u'barcode2']))
        return
    if sample[u"barcode2"] is None:
        sample[u"barcode1"] = barcode1
        sample[u"barcode2"] = barcode2
    return

# def convert_new_fields_to_old(sample):
#     pass

def lanes_and_fqs_match(sample):
    fq1 = sample[u"external_fastq_1"]
    fq2 = sample[u"external_fastq_2"]

    if not isinstance(fq1, list) or not isinstance(fq2, list):
        return False

    if None in fq1 or None in fq2:
        return False

    lane_count = len(sample[u"lanes"])
    if len(fq1) != lane_count or len(fq2) != lane_count:
        return False

    return True

def build_lanes(sample):
    if lanes_and_fqs_match(sample):
        lanes = list(zip(sample[u"lanes"], sample[u"external_fastq_1"], sample[u"external_fastq_2"]))
    else:
        empty = [u""] * len(sample[u"lanes"])
        lanes = list(zip(sample[u"lanes"], empty, empty))
    return lanes

def build_sample_line(header, sample, alt_map, project,
                      lane=1, fastq1=u"", fastq2=u""):
    sample_line = []
    for field in header:
        field = field.lower()
        if field not in alt_map:
            print(u"Warning: Unknown header term: {}. Field will be empty.".format(field))
            sample_line.append(u"")
        if alt_map[field] == u"project":
            sample_line.append(project)
        elif alt_map[field] == u"barcode_combined":
            sample_line.append(u"{}-{}".format(sample[u'barcode1'], sample[u'barcode2']))
        elif alt_map[field] == u"lane":
            sample_line.append(str(lane))
        elif alt_map[field] == u"external_fastq_1":
            sample_line.append(fastq1)
        elif alt_map[field] == u"external_fastq_2":
            sample_line.append(fastq2)
        elif field in alt_map:
            value = sample[alt_map[field]]
            if value is None:
                value = u""
            sample_line.append(str(value))
    return sample_line

def build_sample_lines(header, sample, alt_map, project):
    sample_lines = []
    lanes = build_lanes(sample)
    for lane, fastq1, fastq2 in lanes:
        sample_lines.append(build_sample_line(header, sample, alt_map, project,
                                              lane, fastq1, fastq2))
    return sample_lines

def add_lines(header, body, new_lines, out):
    with open(out, u"w") as outfile:
        outfile.write(u",".join(header) + u"\n")
        outfile.writelines([u",".join(line) + u"\n" for line in body])
        outfile.writelines([u",".join(line) + u"\n" for line in new_lines])

def main(sample_info_yaml, samplesheet, altmap_yaml, out):
    sample = read_sample_info(sample_info_yaml)
    header, body = read_samplesheet(samplesheet)
    project = get_project(header, body)
    altmap = read_alt_mappings(altmap_yaml)
    new_lines = build_sample_lines(header, sample, altmap, project)
    add_lines(header, body, new_lines, out)

if __name__ == u"__main__":
    import sys
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])

