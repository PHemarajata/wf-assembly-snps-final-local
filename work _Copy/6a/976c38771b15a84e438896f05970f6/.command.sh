#!/bin/bash -euo pipefail
mash sketch \
    -o ERS012365 \
    -s 50000 \
    -k 21 \
    -m 1 \
     \
    ERS012365.fasta

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_SKETCH":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
