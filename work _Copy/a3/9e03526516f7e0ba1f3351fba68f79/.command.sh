#!/bin/bash -euo pipefail
mash sketch \
    -o IP-0192 \
    -s 50000 \
    -k 21 \
    -m 1 \
     \
    IP-0192.fasta

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_SKETCH":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
