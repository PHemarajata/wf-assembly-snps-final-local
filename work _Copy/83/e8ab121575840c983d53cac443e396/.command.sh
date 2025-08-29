#!/bin/bash -euo pipefail
# Install required packages
pip install pandas numpy scipy

# Run clustering
python3 /home/phemarajata/wf-assembly-snps-final/bin/cluster_mash.py \
    mash_distances.tsv \
    clusters.tsv \
    --threshold 0.028 \
    --max-cluster-size 50 \
     > cluster_summary.txt

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:CLUSTERING:CLUSTER_GENOMES":
    python: $(python --version | sed 's/Python //')
    pandas: $(python -c "import pandas; print(pandas.__version__)")
    scipy: $(python -c "import scipy; print(scipy.__version__)")
END_VERSIONS
