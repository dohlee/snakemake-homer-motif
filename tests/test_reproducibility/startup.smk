configfile: 'config.yaml'
REFERENCE_FASTA = config['reference']['fasta']
BED = 'data/test.bed'

ALL = []
ALL.append(REFERENCE_FASTA)
ALL.append(BED)

rule all:
    input: ALL

rule reference:
    output: REFERENCE_FASTA
    wrapper: 'http://dohlee-bio.info:9193/test/reference'

rule bed:
    output: BED
    wrapper: 'http://dohlee-bio.info:9193/test/bed'

