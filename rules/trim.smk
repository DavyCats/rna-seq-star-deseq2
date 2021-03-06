def get_fastq(wildcards):
    return samples.loc[wildcards.sample, ["fq1", "fq2"]].dropna()

ruleorder: cutadapt_pe > cutadapt

rule cutadapt_pe:
    input:
        "merged/{sample}.1.fastq.gz",
        "merged/{sample}.2.fastq.gz"
    output:
        fastq1="trimmed/{sample}.1.fastq.gz",
        fastq2="trimmed/{sample}.2.fastq.gz",
        qc="trimmed/{sample}.qc.txt"
    params:
        "-a {} {}".format(config["adapter"], config["params"]["cutadapt-pe"])
    log:
        "logs/cutadapt/{sample}.log"
    wrapper:
        "0.17.4/bio/cutadapt/pe"


rule cutadapt:
    input:
        "merged/{sample}.fastq.gz"
    output:
        fastq="trimmed/{sample}.fastq.gz",
        qc="trimmed/{sample}.qc.txt"
    params:
        "-a {} {}".format(config["adapter"], config["params"]["cutadapt-se"])
    log:
        "logs/cutadapt/{sample}.log"
    wrapper:
        "0.17.4/bio/cutadapt/se"
