#!/bin/bash -euo pipefail
# Check if alignment has at least 3 sequences (minimum for phylogenetic analysis)
seq_count=$(grep -c "^>" cluster_0.aln.fa)

if [ $seq_count -lt 3 ]; then
    echo "WARNING: Alignment has only $seq_count sequences. Gubbins requires at least 3 sequences for phylogenetic analysis."
    echo "Skipping Gubbins analysis for cluster cluster_0"

    # Create empty output files to satisfy pipeline expectations
    touch cluster_0.filtered_polymorphic_sites.fasta
    touch cluster_0.recombination_predictions.gff
    touch cluster_0.node_labelled.final_tree.tre

    # Create versions file for small clusters
    echo '"ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:GUBBINS_CLUSTER":' > versions.yml
    echo '    gubbins: '$(run_gubbins.py --version | sed 's/^/    /') >> versions.yml

    exit 0
fi

# Build Gubbins command with hybrid tree builders if enabled
if [ "true" = "true" ]; then
    # Use hybrid approach with two tree builders
    run_gubbins.py \
        --starting-tree cluster_0.treefile \
        --prefix cluster_0 \
        --first-tree-builder rapidnj \
        --tree-builder iqtree \
        --iterations 3 \
        --min-snps 5 \
        --threads 4 \
         \
        cluster_0.aln.fa || {
        echo "WARNING: Gubbins failed for cluster cluster_0. Creating empty output files."
        touch cluster_0.filtered_polymorphic_sites.fasta
        touch cluster_0.recombination_predictions.gff
        touch cluster_0.node_labelled.final_tree.tre
    }
else
    # Use single tree builder
    run_gubbins.py \
        --starting-tree cluster_0.treefile \
        --prefix cluster_0 \
        --tree-builder iqtree \
        --iterations 3 \
        --min-snps 5 \
        --threads 4 \
         \
        cluster_0.aln.fa || {
        echo "WARNING: Gubbins failed for cluster cluster_0. Creating empty output files."
        touch cluster_0.filtered_polymorphic_sites.fasta
        touch cluster_0.recombination_predictions.gff
        touch cluster_0.node_labelled.final_tree.tre
    }
fi

# Ensure all required output files exist (in case Gubbins partially failed)
if [ ! -f "cluster_0.filtered_polymorphic_sites.fasta" ]; then
    echo "WARNING: Missing filtered_polymorphic_sites.fasta for cluster cluster_0. Creating empty file."
    touch cluster_0.filtered_polymorphic_sites.fasta
fi

if [ ! -f "cluster_0.recombination_predictions.gff" ]; then
    echo "WARNING: Missing recombination_predictions.gff for cluster cluster_0. Creating empty file."
    touch cluster_0.recombination_predictions.gff
fi

if [ ! -f "cluster_0.node_labelled.final_tree.tre" ]; then
    echo "WARNING: Missing node_labelled.final_tree.tre for cluster cluster_0. Creating empty file."
    touch cluster_0.node_labelled.final_tree.tre
fi

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:GUBBINS_CLUSTER":
    gubbins: $(run_gubbins.py --version | sed 's/^/    /')
END_VERSIONS
