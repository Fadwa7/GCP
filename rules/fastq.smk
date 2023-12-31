rule fetch_fastq:
    output: 
        config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
    log: 
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}.sratoolkit.log"
    benchmark: 
        config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}.sratoolkit.txt"
    message: 
       "fetch fastq from NCBI"
    params:
       conda = "sratoolkit",
       outdir = config["RESULTS"] + "Fastq_Files" 
    threads: 8
    shell:
        """
        set +eu &&
        . $(conda info --base)/etc/profile.d/conda.sh &&
        conda activate {params.conda}
        parallel-fastq-dump \
            --outdir {params.outdir} \
            --gzip \
            --sra-id {wildcards.sra} \
            --threads {threads}
        """
