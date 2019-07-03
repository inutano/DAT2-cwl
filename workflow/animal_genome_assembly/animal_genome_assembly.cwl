#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
doc: "Animal Genome Assembly pipeline by Kazuharu Arakawa (@gaou_ak), CWLized by Tazro Ohta (@inutano)"
requirements: {}

inputs:
  nanopore_read_ebi_1:
    type: string
    label: "2.5G"
    default: "ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR209/ERR2092776/nanopore_N2.tar.gz"
  nanopore_read_ebi_2:
    type: string
    label: "1.8G"
    default: "ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR209/ERR2092777/nanopore_him9.tar.gz"
  illumina_read_ebi_1:
    type: string
    label: "3.2G"
    default: "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR209/001/ERR2092781/ERR2092781.fastq.gz"
  illumina_read_ebi_2:
    type: string
    label: "3.4G"
    default: "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR209/002/ERR2092782/ERR2092782.fastq.gz"
  illumina_read_ebi_3:
    type: string
    label: "1.1G"
    default: "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR209/003/ERR2092783/ERR2092783.fastq.gz"
  illumina_read_ebi_4:
    type: string
    label: "1.2G"
    default: "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR209/004/ERR2092784/ERR2092784.fastq.gz"

steps:
  download_nanopore_read_1:
    run: string
    in:
      input_1: nanopore_read_ebi_1
    out:
      - output_1

  download_nanopore_read_2:
    run: string
    in:
      input_1: nanopore_read_ebi_2
    out:
      - output_1

  download_illumina_read_1:
    run: string
    in:
      input_1: illumina_read_ebi_1
    out:
      - output_1

  download_illumina_read_2:
    run: string
    in:
      input_1: illumina_read_ebi_2
    out:
      - output_1

  download_illumina_read_3:
    run: string
    in:
      input_1: illumina_read_ebi_3
    out:
      - output_1

  download_illumina_read_4:
    run: string
    in:
      input_1: illumina_read_ebi_4
    out:
      - output_1






outputs:
  step-1_output_1:
    type: File
    outputSource: step-1/output_1
