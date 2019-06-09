from pathlib import Path
DATA_DIR = Path(config['data_dir'])
RESULT_DIR = Path(config['result_dir'])

HME = config['homer_motif_enrichment']
checkpoint homer_motif_enrichment:
    input:
        bed = DATA_DIR / '{sample}.bed',
        genome = config['reference']['fasta'],
    output:
        homer_results = directory(str(RESULT_DIR / '{sample}' / 'homerResults')),
        known_results = directory(str(RESULT_DIR / '{sample}' / 'knownResults')),
    params:
        # Mask repeats/lower case sequence.
        # Default: False
        mask = HME['mask'],
        # Removes background positions overlappig with target positions.
        # Default: False
        bg = HME['bg'],
        # Chop up large background regions to the avg size of target regions.
        # Default: False
        chopify = HME['chopify'],
        # Motif length.
        # NOTE: values greater than 12 may cause the program to run out of memory.
        # In these cases decrease the number of sequences analyzed (-N),
        # or try analyzing shorter sequence regions (i.e. -size 100).
        # Default: 8,10,12
        len_ = HME['len_'],
        # Fragment size to use for motif finding.
        # Options:
        # -size <#,#> : For example, -size -100,50 will get sequences from -100 to +50 relative from center.
        # -size given : uses the exact regions you give it.
        # Default: 200
        size = HME['size'],
        # Numter of motifs to optimize.
        # Default: 25
        S = HME['S'],
        # Global optimization, searches for strings with # mismatches.
        # Default: 2
        mis = HME['mis'],
        # Don't search reverse strand for motifs.
        # Default: False
        norevopp = HME['norevopp'],
        # Don't search for de novo motif enrichment.
        # Default: False
        nomotif = HME['nomotif'],
        # Output RNA motif logos and compare to RNA motif database, automatically sets -norevopp.
        # Default: False
        rna = HME['rna'],
        # Known motif options/visualization
        # Check against motif collections.
        # Default: auto
        mset = HME['mset'],
        # Just visualize de novo motifs, don't check similarity with known motifs.
        # Default: False
        basic = HME['basic'],
        # Scale sequence logos by information content.
        # Default: Doesn't scale.
        bits = HME['bits'],
        # Don't search for de novo vs. known motif similarity.
        # Default: False
        nocheck = HME['nocheck'],
        # Known motifs to check against de novo motifs.
        # Default: False,
        mcheck = HME['mcheck'],
        # [DANGEROUS] Allow adjustment of the degeneracy threshold for known motifs to improve p-value.
        # Default: False
        float_ = HME['float_'],
        # Don't search for known motif enrichment.
        # Default: False
        noknown = HME['noknown'],
        # Known motifs to check for enrichment.
        # Default: False
        mknown = HME['mknown'],
        # Omit humor.
        # Default: False
        nofacts = HME['nofacts'],
        # Use weblogo/seqlogo/ghostscript to generate logos, default uses SVG now.
        # Default: False
        seqlogo = HME['seqlogo'],
        # Sequence normalization options
        # Use GC% for sequence content normalization, now the default.
        # Default: True
        gc = HME['gc'],
        # Use CpG% instead of GC% for sequence content normalization.
        # Default: False
        cpg = HME['cpg'],
        # No CG correction.
        # Default: False
        noweight = HME['noweight'],
        # Advanced options.
        # Use hypergeometric for p-values, binomial is default.
        # Default: False
        h = HME['h'],
        # Number of sequences to use for motif finding.
        # Default: max(50k, 2x input)
        N = HME['N'],
        # Use local background, # of equal size regions around peaks to use i.e. 2.
        # Default: False
        local = HME['local'],
        # Remove redundant sequences matching greater than # percent, i.e. redundant 0.5.
        # Default: False
        redundant = HME['redundant'],
        # Maximum percentage of N's in sequence to consider for motif finding.
        # Default: 0.7
        maxN = HME['maxN'],
        # Motifs to mask before motif finding.
        # -maskMotif <motif file 1> [motif file 2]
        # Default: False
        maskMotif = HME['maskMotif'],
        # Motifs to optimize or change length of
        # -opt <motif file 1> [motif file 2]...
        # Default: False
        opt = HME['opt'],
        # Randomize target and background sequences labels.
        # Default: False
        rand = HME['rand'],
        # Use file for target and background - first argument is list of peak ids for targets.
        # -ref <peak file>
        # Default: False
        ref = HME['ref'],
        # Perform analysis of individual oligo enrichment.
        # Default: False
        oligo = HME['oligo'],
        # Dump fasta files for target and background sequences for use with other programs.
        # Default: False
        dumpFasta = HME['dumpFasta'],
        # Force new background files to be created.
        # Default: False
        preparse = HME['preparse'],
        # Location to search for preparsed file and/or place new files.
        # Default: False
        preparsedDir = HME['preparsedDir'],
        # Keep temporary files.
        # Default: False
        keepFiles = HME['keepFiles'],
        # Calculate empirical FDR for de novo discovery #=number of randomizations
        # Default: False
        fdr = HME['fdr'],
        # Use homer2 instead of original homer.
        # Default: True
        homer2 = HME['homer2'],
        # Length of lower-order oligos to normalize in background.
        # Default: 3
        nlen = HME['nlen'],
        # Max normalization iterations.
        # Default: 160
        nmax = HME['nmax'],
        # Weight sequences to neutral frequencies, i.e. 25%, 6.25%, etc.
        # Default: False
        neutral = HME['neutral'],
        # Lower-order oligo normalization for oligo table, use if -nlen isn't working well.
        # Default: False
        olen = HME['olen'],
        # Maximum expected motif instance per bp in random sequence.
        # Default: 0.01
        e = HME['e'],
        # Size in MB for statistics cache
        # Default: 500
        cache = HME['cache'],
        # Skip full masking after finding motifs, similar to original homer.
        # Default: False
        quickMask = HME['quickMask'],
        # Stop looking for motifs when seed logp score gets above #.
        # Default: -10
        minlp = HME['minlp'],
    threads: config['threads']['homer_motif_enrichment']
    log:
        'logs/homer_motif_enrichment/{sample}.log'
    benchmark:
        repeat('benchmarks/homer_motif_enrichment/{sample}.tsv', 1)
    wrapper:
        'http://dohlee-bio.info:9193/homer/motif/enrichment'

def motif_input(wildcards):
    import os
    homer_results_dir = Path(checkpoints.homer_motif_enrichment.get(sample=wildcards.sample).output.homer_results)

    if os.path.exists(str(homer_results_dir / 'motifs%s.motif') % wildcards.motif_no):
        return str(homer_results_dir / 'motif%s.motif') % wildcards.motif_no
    else:
        return str(homer_results_dir / 'motif%sRV.motif') % wildcards.motif_no

rule homer_motif_find:
    input:
        bed = DATA_DIR / '{sample}.bed',
        genome = config['reference']['fasta'],
        motif = motif_input,
    output:
        homer_result = RESULT_DIR / '{sample}' / '{sample}.motif{motif_no}.homer_result'
    params:
        extra = ''
    threads: config['threads']['homer_motif_find']
    resources: motif_lock = 1
    log:
        'logs/homer_motif_find/{sample}.motif{motif_no}.log'
    benchmark:
        repeat('benchmarks/homer_motif_find/{sample}.motif{motif_no}.tsv', 1)
    wrapper:
        'http://dohlee-bio.info:9193/homer/motif/find'

