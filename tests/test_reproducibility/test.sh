#!/bin/bash
set -e

snakemake -s startup.smk -p -j1

snakemake -s ../../Snakefile --configfile config.yaml --config result_dir=result0 --resources motif_lock=1 -pr -j2
snakemake -s ../../Snakefile --configfile config.yaml --config result_dir=result1 --resources motif_lock=1 -pr -j2

a=$(md5sum result0/test/test.motif1.homer_result | cut -d' ' -f1)
b=$(md5sum result1/test/test.motif1.homer_result | cut -d' ' -f1)

if [[ $a == $b ]]; then
    # Reproducible!
    curl https://gist.githubusercontent.com/dohlee/3ea154d52932b27d042566605a2cb9e2/raw/update_reproducibility.sh -H 'Cache-control: no-cache' | bash /dev/stdin -y
else
    # Not reproducible!
    curl https://gist.githubusercontent.com/dohlee/3ea154d52932b27d042566605a2cb9e2/raw/update_reproducibility.sh -H 'Cache-control: no-cache' | bash /dev/stdin -n
fi
