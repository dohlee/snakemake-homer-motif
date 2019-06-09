from pathlib import Path
import pandas as pd

configfile: 'config.yaml'
manifest = pd.read_csv(config['manifest'])

include: 'rules/homer.smk'

DATA_DIR = Path(config['data_dir'])
RESULT_DIR = Path(config['result_dir'])
N_MOTIFS = config['n_motifs']
SAMPLES = manifest.name.values

HOMER_RESULTS = expand(str(RESULT_DIR / '{sample}' / 'homerResults'), sample=SAMPLES)
MOTIF_INSTANCES = expand(str(RESULT_DIR / '{sample}' / '{sample}.motif{motif_no}.homer_result'), sample=SAMPLES, motif_no=range(1, N_MOTIFS+1))

ALL = []
ALL.append(HOMER_RESULTS)
ALL.append(MOTIF_INSTANCES)

rule all:
    input: ALL
