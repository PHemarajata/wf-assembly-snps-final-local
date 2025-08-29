#!/bin/bash -euo pipefail
# Create a combined sketch file
mash paste combined *.msh

# Calculate pairwise distances
mash dist \
     \
    combined.msh \
    combined.msh > mash_distances.tsv

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:MASH_DIST":
    mash: $(mash --version 2>&1 | sed 's/^/    /')
END_VERSIONS
