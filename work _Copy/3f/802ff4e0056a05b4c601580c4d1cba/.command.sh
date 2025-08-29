#!/bin/bash -euo pipefail
# Create input file for SKA
    cat > cluster_4_input.tsv <<'EOFSKA'
IP-0081	IP-0081.fasta
IP-0082	IP-0082.fasta
IP-0083	IP-0083.fasta
IP-0084	IP-0084.fasta
IP-0085	IP-0085.fasta
IP-0086	IP-0086.fasta
IP-0087	IP-0087.fasta
IP-0088	IP-0088.fasta
IP-0089	IP-0089.fasta
IP-0090	IP-0090.fasta
IP-0091	IP-0091.fasta
IP-0092	IP-0092.fasta
IP-0093	IP-0093.fasta
IP-0094	IP-0094.fasta
IP-0095	IP-0095.fasta
IP-0096	IP-0096.fasta
IP-0097	IP-0097.fasta
IP-0098	IP-0098.fasta
IP-0099	IP-0099.fasta
IP-0100	IP-0100.fasta
IP-0101	IP-0101.fasta
IP-0102	IP-0102.fasta
IP-0103	IP-0103.fasta
IP-0104	IP-0104.fasta
IP-0105	IP-0105.fasta
IP-0106	IP-0106.fasta
IP-0107	IP-0107.fasta
IP-0108	IP-0108.fasta
IP-0109	IP-0109.fasta
IP-0110	IP-0110.fasta
IP-0111	IP-0111.fasta
IP-0112	IP-0112.fasta
IP-0113	IP-0113.fasta
IP-0114	IP-0114.fasta
IP-0115	IP-0115.fasta
IP-0116	IP-0116.fasta
IP-0117	IP-0117.fasta
IP-0118	IP-0118.fasta
IP-0119	IP-0119.fasta
IP-0120	IP-0120.fasta
IP-0121	IP-0121.fasta
IP-0122	IP-0122.fasta
IP-0123	IP-0123.fasta
IP-0124	IP-0124.fasta
IP-0125	IP-0125.fasta
IP-0126	IP-0126.fasta
IP-0127	IP-0127.fasta
IP-0128	IP-0128.fasta
IP-0129	IP-0129.fasta
IP-0130	IP-0130.fasta
EOFSKA

    # Verify input file was created correctly
    echo "Input file contents:"
    cat cluster_4_input.tsv
    
    # Verify that all files exist
    echo "Checking file existence:"
    for file in *.fasta *.fa *.fna *.fas *.fsa; do
        if [ -f "$file" ]; then
            echo "Found: $file"
        fi
    done 2>/dev/null || echo "No FASTA files found with standard extensions"
    
    # Build SKA file
    ska build \
        -o cluster_4 \
        -f cluster_4_input.tsv \
         || {
        echo "WARNING: SKA build failed for cluster cluster_4. Creating empty SKA file."
        touch cluster_4.skf
    }

    # Ensure SKA file exists
    if [ ! -f "cluster_4.skf" ]; then
        echo "WARNING: Missing SKA file for cluster cluster_4. Creating empty file."
        touch cluster_4.skf
    fi

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_BUILD":
        ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
    END_VERSIONS
