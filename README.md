# snakemake-homer-motif

[![Build Status](https://travis-ci.org/dohlee/snakemake-homer-motif.svg?branch=master)](https://travis-ci.org/dohlee/snakemake-homer-motif)

This pipeline finds enriched motifs in given genomic intervals.
In the first pass, the pipeline calls HOMER's `findMotifsGenome.pl` without `-find` option to get enriched motifs and its significance.
The pipeline runs second pass of `findMotifsGenome.pl` with `-find` option to obtain exact locations of top *k* enriched motifs identified in the first pass. (Note that *k* can be configured by the user.)

