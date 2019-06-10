# snakemake-homer-motif

[![Build Status](https://travis-ci.org/dohlee/snakemake-homer-motif.svg?branch=master)](https://travis-ci.org/dohlee/snakemake-homer-motif)
![Reproduction Status](https://img.shields.io/endpoint.svg?url=https://gist.githubusercontent.com/dohlee/64f3d93416b91d784d565c0f335cf28c/raw/homer-motif.json)

This pipeline finds enriched motifs in given genomic intervals.
In the first pass, the pipeline calls HOMER's `findMotifsGenome.pl` without `-find` option to get enriched motifs and its significance.
The pipeline runs second pass of `findMotifsGenome.pl` with `-find` option to obtain exact locations of top *k* enriched motifs identified in the first pass. (Note that *k* can be configured by the user.)

Warning: This pipeline is not reproducible, as homer does not provide ways to set random seed.

## Creating conda environment

You can create a new conda environment from `environment.yaml` file,
```shell
$ conda env create -f environment.yaml
```

or you can use --use-conda option when executing `snakemake`.
```shell
$ snakemake --use-conda --resources motif_lock=1 -p -j 32
```

## Removing conda environment

If you created a new conda environment, remove the environment when you are done with the pipeline.
```shell
$ conda env remove -n homer-motif
```

## Configuring config.yaml

Every parameter for tools should be configured in `config.yaml`. You should not modify snakemake rules in `rules` directory, unless you have good reasons to tweak it.

## Preparing manifest file

All the samples that you are going to process should be specified in `manifest.csv` file. The first row should be a header, having 'name' as mandatory field.

You can change the name of manifest file, but you have to change the value of `manifest` field in `config.yaml`, or execute `snakemake` with `--config` option.
```shell
$ snakemake --resources motif_lock=1 -p -j 32 --config manifest=<YOUR_MANIFEST_FILE>
```

## Running the pipeline
After setting all the configurations and manifest, you can dry-run the pipeline with `-n` option and see if the pipeline works appropriately. Please note that even the pipeline seems OK for now, some unexpected errors may get you in trouble at runtime. In this case, you should inspect log files in `logs` directory, and troubleshoot the error.
```shell
$ snakemake -n
```
If it seems OK, provide the pipeline with appropriate number of cores with `-j` option, and it will find optimal execution scenario that maximizes the usage of cores. `-p` option makes the actual commands to be printed out when they are to be executed.
```shell
$ snakemake -j 32 -p
```

## Estimated runtime
TODO: Provide rough estimates of running time.
