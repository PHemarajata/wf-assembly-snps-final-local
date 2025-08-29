#!/bin/bash -euo pipefail
# Create alignment from SKA file
ska align \
     \
    cluster_6.skf > cluster_6.aln.fa || {
    echo "WARNING: SKA align failed for cluster cluster_6. Creating empty alignment file."
    touch cluster_6.aln.fa
}

# Ensure alignment file exists
if [ ! -f "cluster_6.aln.fa" ]; then
    echo "WARNING: Missing alignment file for cluster cluster_6. Creating empty file."
    touch cluster_6.aln.fa
fi

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_ALIGN":
    ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
END_VERSIONS
