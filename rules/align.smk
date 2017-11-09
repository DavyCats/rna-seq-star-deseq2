def get_trimmed(wildcards):
    paired = samples.loc[wildcards.sample, "fq2"]
    if type(paired) != float:
        # paired-end sample
        return expand("trimmed/{sample}.{group}.fastq.gz",
                      sample=wildcards.sample, group=[1, 2])
    # single end sample
    return ["trimmed/{sample}.fastq.gz".format(
        sample=wildcards.sample)]


rule align:
    input:
        sample=get_trimmed
    output:
        # see STAR manual for additional output files
        "star/{sample}/Aligned.out.bam",
        "star/{sample}/ReadsPerGene.out.tab"
    log:
        "logs/star/{sample}.log"
    params:
        # path to STAR reference genome index
        index=config["ref"]["index"],
        # optional parameters
        extra="--quantMode GeneCounts --sjdbGTFfile {} {}".format(
              config["ref"]["annotation"], config["params"]["star"])
    threads: 24
    wrapper:
        "0.17.4/bio/star/align"
