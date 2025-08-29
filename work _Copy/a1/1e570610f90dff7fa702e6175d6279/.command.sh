#!/bin/bash -euo pipefail
mash sketch \
    -o GCF_001207785_2_Malaysia \
    -s 50000 \
    -k 21 \
    -m 1 \
     \
    GCF_001207785_2_Malaysia.fasta

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_SKETCH":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
