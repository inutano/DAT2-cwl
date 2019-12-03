#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
doc: "Animal Genome Assembly pipeline by Kazuharu Arakawa (@gaou_ak), CWLized by Tazro Ohta (@inutano)"
requirements: {}

inputs:
  THREADS:
    type: int
  INPUT_LONGREAD:
    type: File
  INPUT_SHORTREAD:
    type: File
  ESTIMATED_GENOME_SIZE:
    type: string

steps:
  bbmap-stats-initial:
    run: ../../tool/bbmap/bbmap-stats/bbmap-stats.cwl
    in:
      input_fastq: INPUT_LONGREAD
    out:
      - stats
  jellyfish-count:
    run: ../../tool/jellyfish/count/jellyfish-count.cwl
    in:
      input_file: INPUT_SHORTREAD
      threads: THREADS
    out:
      - kmer0
  jellyfish-histo:
    run: ../../tool/jellyfish/histo/jellyfish-histo.cwl
    in:
      kmer_db: jellyfish-count/kmer0
      threads: THREADS
    out:
      - stdout
  nanoplot:
    run: ../../tool/nanoplot/nanoplot.cwl
    in:
      sequence: INPUT_LONGREAD
      threads: THREADS
    out:
      - HistogramReadlength
      - LogTransformed_HistogramReadlength
      - Yield_By_Length
      - LengthvsQualityScatterPlot_dot
      - Weighted_HistogramReadlength
      - LengthvsQualityScatterPlot_kde
      - Weighted_LogTransformed_HistogramReadlength
      - NanoPlot-report
      - NanoStats
  # canu:
  #   run: ../../tool/canu/canu.cwl
  #   in:
  #     input_fastq: INPUT_LONGREAD
  #     genomeSize: ESTIMATED_GENOME_SIZE
  #     maxThreads: THREADS
  #   out:
  #     - contigs
  # bbmap-stats-canu-contigs:
  #   run: ../../tool/bbmap/bbmap-stats/bbmap-stats.cwl
  #   in:
  #     input_fastq: canu/contigs
  #   out:
  #     - stats
  wtdbg2:
    run: ../../tool/wtdbg2/wtdbg2/wtdbg2.cwl
    in:
      sequence: INPUT_LONGREAD
      genome_size: ESTIMATED_GENOME_SIZE
      threads: THREADS
    out:
      - dot_file_initialized_graph
      - nodes
      - reads
      - dot_file_after_transitive_reduction
      - dot_file_after_merging_bubble
      - kbmap
      - binkmer
      - closed_bins
      - clps
      - dot_contig
      - contig_layout
      - events
      - dot_unitigs
      - nodes_unitigs
      - kmerdep
  wtpoa-cns:
    run: ../../tool/wtdbg2/wtpoa-cns/wtpoa-cns.cwl
    in:
      input_contigs: wtdbg2/contig_layout
      threads: THREADS
    out:
      - output_file
  bbmap-stats-wtdbg2-contigs:
    run: ../../tool/bbmap/bbmap-stats/bbmap-stats.cwl
    in:
      input_fastq: wtpoa-cns/output_file
    out:
      - stats
  bwa-index:
    run: ../../tool/bwa/index/bwa-index.cwl
    in:
      input_fasta: wtpoa-cns/output_file
    out:
      - amb
      - ann
      - bwt
      - pac
      - sa
  bwa-mem:
    run: ../../tool/bwa/mem/bwa-mem.cwl
    in:
      fastq_forward: INPUT_SHORTREAD
      index_base: wtpoa-cns/output_file
      amb: bwa-index/amb
      ann: bwa-index/ann
      bwt: bwa-index/bwt
      pac: bwa-index/pac
      sa: bwa-index/sa
      threads: THREADS
    out:
      - output
  samtools-view:
    run: ../../tool/samtools/view/samtools-view.cwl
    in:
      threads: THREADS
      input_file: bwa-mem/output
    out:
      - bam
  samtools-sort:
    run: ../../tool/samtools/sort/samtools-sort.cwl
    in:
      input_bamfile: samtools-view/bam
      threads: THREADS
    out:
      - sorted_bam
  samtools-index:
    run: ../../tool/samtools/index/samtools-index.cwl
    in:
      input_bamfile: samtools-sort/sorted_bam
    out:
      - bam_index
  pilon-1:
    run: ../../tool/pilon/pilon.cwl
    in:
      genome_fasta: wtpoa-cns/output_file
      aligned_bam: samtools-sort/sorted_bam
      bam_index: samtools-index/bam_index
      threads: THREADS
    out:
      - fasta
      - bam
      - bam_index
  pilon-2:
    run: ../../tool/pilon/pilon.cwl
    in:
      genome_fasta: pilon-1/fasta
      aligned_bam: samtools-sort/sorted_bam
      bam_index: samtools-index/bam_index
      threads: THREADS
    out:
      - fasta
      - bam
      - bam_index
  pilon-3:
    run: ../../tool/pilon/pilon.cwl
    in:
      genome_fasta: pilon-2/fasta
      aligned_bam: samtools-sort/sorted_bam
      bam_index: samtools-index/bam_index
      threads: THREADS
    out:
      - fasta
      - bam
      - bam_index
  pilon-4:
    run: ../../tool/pilon/pilon.cwl
    in:
      genome_fasta: pilon-3/fasta
      aligned_bam: samtools-sort/sorted_bam
      bam_index: samtools-index/bam_index
      threads: THREADS
    out:
      - fasta
      - bam
      - bam_index

outputs:
  bbmap-stats-initial_stats:
    type: File
    outputSource: bbmap-stats-initial/stats
  jellyfish-histo_stdout:
    type: File
    outputSource: jellyfish-histo/stdout
  nanoplot_HistogramReadlength:
    type: File
    outputSource: nanoplot/HistogramReadlength
  nanoplot_LogTransformed_HistogramReadlength:
    type: File
    outputSource: nanoplot/LogTransformed_HistogramReadlength
  nanoplot_Yield_By_Length:
    type: File
    outputSource: nanoplot/Yield_By_Length
  nanoplot_LengthvsQualityScatterPlot_dot:
    type: File
    outputSource: nanoplot/LengthvsQualityScatterPlot_dot
  nanoplot_Weighted_HistogramReadlength:
    type: File
    outputSource: nanoplot/Weighted_HistogramReadlength
  nanoplot_LengthvsQualityScatterPlot_kde:
    type: File
    outputSource: nanoplot/LengthvsQualityScatterPlot_kde
  nanoplot_Weighted_LogTransformed_HistogramReadlength:
    type: File
    outputSource: nanoplot/Weighted_LogTransformed_HistogramReadlength
  nanoplot_NanoPlot-report:
    type: File
    outputSource: nanoplot/NanoPlot-report
  nanoplot_NanoStats:
    type: File
    outputSource: nanoplot/NanoStats
  wtpoa-cns_output_file:
    type: File
    outputSource: wtpoa-cns/output_file
  bbmap-stats-wtdbg2-contigs_stats:
    type: File
    outputSource: bbmap-stats-wtdbg2-contigs/stats
  samtools-sort_sorted_bam:
    type: File
    outputSource: samtools-sort/sorted_bam
  samtools-index_bam_index:
    type: File
    outputSource: samtools-index/bam_index
  pilon-1_fasta:
    type: File
    outputSource: pilon-1/fasta
  pilon-2_fasta:
    type: File
    outputSource: pilon-2/fasta
  pilon-3_fasta:
    type: File
    outputSource: pilon-3/fasta
  pilon-4_fasta:
    type: File
    outputSource: pilon-4/fasta
