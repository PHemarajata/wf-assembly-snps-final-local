#!/bin/bash -euo pipefail
mash sketch \
    -o GCF_003268105_1_Viet_Nam \
    -s 50000 \
    -k 21 \
    -m 1 \
     \
    GCF_003268105_1_Viet_Nam.fasta

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_SKETCH":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
