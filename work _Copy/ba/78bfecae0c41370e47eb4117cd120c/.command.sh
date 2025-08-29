#!/bin/bash -euo pipefail
mash sketch \
    -o GCF_002110985_1_USA_Puerto_Rico \
    -s 50000 \
    -k 21 \
    -m 1 \
     \
    GCF_002110985_1_USA_Puerto_Rico.fasta

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_SKETCH":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
