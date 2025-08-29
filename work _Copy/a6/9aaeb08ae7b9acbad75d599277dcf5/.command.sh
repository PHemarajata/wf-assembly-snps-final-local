#!/bin/bash -euo pipefail
mash sketch \
    -o GCF_002111145_1_USA_Arizona_ex_Costa_Rica \
    -s 50000 \
    -k 21 \
    -m 1 \
     \
    GCF_002111145_1_USA_Arizona_ex_Costa_Rica.fasta

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_SKETCH":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
