#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

params.stability_path = 'stability.files'
// /Users/shivaaryal/Downloads/my_mothur_flow/stability.files


process reduceSequencingPCRErrors {

    input:
        val(string)

    output:
        stdout

    print params.stability_path
    """
    #! /my_mothur_flow/mothur

    make.file(inputdir=mothurhome, type=fastq, prefix=stability)

    make.contigs(file=$params.stability_path, processors=16)
   
    summary.seqs(fasta=stability.trim.contigs.fasta, count=stability.contigs.count_table)

    make.contigs(file=stability.files, maxambig=0, maxlength=275, maxhomop=8)

    """
}

process processImprovedSequences1 {

    input:
        val(string)

    output:
        stdout

    print "Executing another process"

    """
    #! /mothur
   
    unique.seqs(fasta=stability.trim.contigs.fasta, count=stability.contigs.count_table)

    summary.seqs(count=stability.trim.contigs.count_table)


    """
}

process processImprovedSequences2 {

    input:
        val(string)

    output:
        stdout

    print "Executing another process 2"

    """
    #!/mothur
   
    pcr.seqs(fasta=silva.bacteria.fasta, start=11895, end=25318, keepdots=F)

    rename.file(input=silva.bacteria.pcr.fasta, new=silva.v4.fasta)


    """
}

// process accessingErrorRates {

//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     get.groups(count=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, fasta=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.fasta, groups=Mock)

//     seq.error(fasta=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.fasta, count=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, reference=HMP_MOCK.v35.fasta, aligned=F)

//     dist.seqs(fasta=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.fasta, cutoff=0.03)
//     cluster(column=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.dist, count=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)
//     make.shared(list=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.opti_mcc.list, count=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, label=0.03)
//     rarefaction.single(shared=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.opti_mcc.shared)

//     """

// }

// process preparingForAnalysis {
//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     remove.groups(count=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, fasta=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pick.fasta, taxonomy=stability.trim.contigs.unique.good.filter.unique.precluster.denovo.vsearch.pds.wang.pick.taxonomy, groups=Mock)

//     rename.file(fasta=current, count=current, taxonomy=current, prefix=final)

//     """
// }

// process oTUs {
//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     dist.seqs(fasta=final.fasta, cutoff=0.03)

//     cluster(column=final.dist, count=final.count_table)

//     make.shared(list=final.opti_mcc.list, count=final.count_table, label=0.03)

//     classify.otu(list=final.opti_mcc.list, count=final.count_table, taxonomy=final.taxonomy, label=0.03)

//     """
// }

// process aSVs {
//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     make.shared(count=final.count_table)

//     classify.otu(list=final.asv.list, count=final.count_table, taxonomy=final.taxonomy, label=ASV)

//     """
// }

// process phylotypes {
//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     phylotype(taxonomy=final.taxonomy)

//     make.shared(list=final.tx.list, count=final.count_table, label=1)

//     classify.otu(list=final.tx.list, count=final.count_table, taxonomy=final.taxonomy, label=1)

//     """
// }

// process phylogenetic {
//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     dist.seqs(fasta=final.fasta, output=lt)
//     clearcut(phylip=final.phylip.dist)

//     """
// }

// process analysis {
//     output:
//         stdout
//     """
//     #!/Users/shivaaryal/Downloads/my_mothur_flow/mothur

//     count.groups(shared=final.opti_mcc.shared)

//     sub.sample(shared=final.opti_mcc.shared, size=2403)

//     """
// }


workflow {

    stability_path = channel.of(params.stability_path)

    reduceSequencingPCRErrors(stability_path)
    // reduceSequencingPCRErrors()
    // processImprovedSequences1(reduceSequencingPCRErrors.out)

    // processImprovedSequences2(processImprovedSequences1.out)

}