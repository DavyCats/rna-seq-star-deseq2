def get_fastq(wildcards):
    try:
        field = "fq{}".format(wildcards.group)
    except AttributeError:
        field = "fq1"
    result = samples.loc[wildcards.sample, [field]][field]
    if type(result) == str:
        return [result]
    return result.tolist()

rule merge_pe:
    input:
        get_fastq
    output:
        "merged/{sample}.{group}.fastq.gz",
    shell:
        "cat {input} > {output}"

rule merge:
    input:
        get_fastq
    output:
        "merged/{sample}.fastq.gz",
    shell:
        "cat {input} > {output}"
