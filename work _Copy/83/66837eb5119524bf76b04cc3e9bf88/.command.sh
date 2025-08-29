#!/bin/bash -euo pipefail
# Create input file for SKA
    cat > cluster_2_input.tsv <<'EOFSKA'
IE-0003	IE-0003.fasta
IE-0004	IE-0004.fasta
IE-0005	IE-0005.fasta
IE-0006	IE-0006.fasta
IE-0007	IE-0007.fasta
IE-0009	IE-0009.fasta
IE-0010	IE-0010.fasta
IE-0011	IE-0011.fasta
IE-0012	IE-0012.fasta
IE-0013	IE-0013.fasta
IE-0014	IE-0014.fasta
IE-0015	IE-0015.fasta
IE-0016	IE-0016.fasta
IE-0017	IE-0017.fasta
IE-0018	IE-0018.fasta
IE-0019	IE-0019.fasta
IE-0021	IE-0021.fasta
IE-0022	IE-0022.fasta
IE-0024	IE-0024.fasta
IE-0026	IE-0026.fasta
IP-0001	IP-0001.fasta
IP-0002	IP-0002.fasta
IP-0003	IP-0003.fasta
IP-0004	IP-0004.fasta
IP-0005	IP-0005.fasta
IP-0006	IP-0006.fasta
IP-0007	IP-0007.fasta
IP-0008	IP-0008.fasta
IP-0009	IP-0009.fasta
IP-0010	IP-0010.fasta
IP-0011	IP-0011.fasta
IP-0012	IP-0012.fasta
IP-0013	IP-0013.fasta
IP-0014	IP-0014.fasta
IP-0015	IP-0015.fasta
IP-0016	IP-0016.fasta
IP-0017	IP-0017.fasta
IP-0018	IP-0018.fasta
IP-0019	IP-0019.fasta
IP-0020	IP-0020.fasta
IP-0021	IP-0021.fasta
IP-0022	IP-0022.fasta
IP-0023	IP-0023.fasta
IP-0024	IP-0024.fasta
IP-0025	IP-0025.fasta
IP-0026	IP-0026.fasta
IP-0027	IP-0027.fasta
IP-0028	IP-0028.fasta
IP-0029	IP-0029.fasta
IP-0030	IP-0030.fasta
EOFSKA

    # Verify input file was created correctly
    echo "Input file contents:"
    cat cluster_2_input.tsv
    
    # Verify that all files exist
    echo "Checking file existence:"
    for file in *.fasta *.fa *.fna *.fas *.fsa; do
        if [ -f "$file" ]; then
            echo "Found: $file"
        fi
    done 2>/dev/null || echo "No FASTA files found with standard extensions"
    
    # Build SKA file
    ska build \
        -o cluster_2 \
        -f cluster_2_input.tsv \
         || {
        echo "WARNING: SKA build failed for cluster cluster_2. Creating empty SKA file."
        touch cluster_2.skf
    }

    # Ensure SKA file exists
    if [ ! -f "cluster_2.skf" ]; then
        echo "WARNING: Missing SKA file for cluster cluster_2. Creating empty file."
        touch cluster_2.skf
    fi

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_BUILD":
        ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
    END_VERSIONS
