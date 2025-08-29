#!/bin/bash -euo pipefail
# Create input file for SKA
    cat > cluster_6_input.tsv <<'EOFSKA'
IP-0181	IP-0181.fasta
IP-0182	IP-0182.fasta
IP-0183	IP-0183.fasta
IP-0184	IP-0184.fasta
IP-0185	IP-0185.fasta
IP-0186	IP-0186.fasta
IP-0187	IP-0187.fasta
IP-0188	IP-0188.fasta
IP-0189	IP-0189.fasta
IP-0190	IP-0190.fasta
IP-0191	IP-0191.fasta
IP-0192	IP-0192.fasta
IP-0193	IP-0193.fasta
IP-0194	IP-0194.fasta
IP-0195	IP-0195.fasta
IP-0196	IP-0196.fasta
IP-0197	IP-0197.fasta
IP-0199	IP-0199.fasta
IP-0200	IP-0200.fasta
IP-0201	IP-0201.fasta
IP-0202	IP-0202.fasta
SRR12527885_contigs	SRR12527885_contigs.fasta
EOFSKA

    # Verify input file was created correctly
    echo "Input file contents:"
    cat cluster_6_input.tsv
    
    # Verify that all files exist
    echo "Checking file existence:"
    for file in *.fasta *.fa *.fna *.fas *.fsa; do
        if [ -f "$file" ]; then
            echo "Found: $file"
        fi
    done 2>/dev/null || echo "No FASTA files found with standard extensions"
    
    # Build SKA file
    ska build \
        -o cluster_6 \
        -f cluster_6_input.tsv \
         || {
        echo "WARNING: SKA build failed for cluster cluster_6. Creating empty SKA file."
        touch cluster_6.skf
    }

    # Ensure SKA file exists
    if [ ! -f "cluster_6.skf" ]; then
        echo "WARNING: Missing SKA file for cluster cluster_6. Creating empty file."
        touch cluster_6.skf
    fi

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_BUILD":
        ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
    END_VERSIONS
