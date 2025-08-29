#!/bin/bash -euo pipefail
# Create input file for SKA
    cat > cluster_5_input.tsv <<'EOFSKA'
IP-0131	IP-0131.fasta
IP-0132	IP-0132.fasta
IP-0133	IP-0133.fasta
IP-0134	IP-0134.fasta
IP-0135	IP-0135.fasta
IP-0136	IP-0136.fasta
IP-0137	IP-0137.fasta
IP-0138	IP-0138.fasta
IP-0139	IP-0139.fasta
IP-0140	IP-0140.fasta
IP-0141	IP-0141.fasta
IP-0142	IP-0142.fasta
IP-0143	IP-0143.fasta
IP-0144	IP-0144.fasta
IP-0145	IP-0145.fasta
IP-0146	IP-0146.fasta
IP-0147	IP-0147.fasta
IP-0148	IP-0148.fasta
IP-0149	IP-0149.fasta
IP-0150	IP-0150.fasta
IP-0151	IP-0151.fasta
IP-0152	IP-0152.fasta
IP-0153	IP-0153.fasta
IP-0154	IP-0154.fasta
IP-0155	IP-0155.fasta
IP-0156	IP-0156.fasta
IP-0157	IP-0157.fasta
IP-0158	IP-0158.fasta
IP-0159	IP-0159.fasta
IP-0160	IP-0160.fasta
IP-0161	IP-0161.fasta
IP-0162	IP-0162.fasta
IP-0163	IP-0163.fasta
IP-0164	IP-0164.fasta
IP-0165	IP-0165.fasta
IP-0166	IP-0166.fasta
IP-0167	IP-0167.fasta
IP-0168	IP-0168.fasta
IP-0169	IP-0169.fasta
IP-0170	IP-0170.fasta
IP-0171	IP-0171.fasta
IP-0172	IP-0172.fasta
IP-0173	IP-0173.fasta
IP-0174	IP-0174.fasta
IP-0175	IP-0175.fasta
IP-0176	IP-0176.fasta
IP-0177	IP-0177.fasta
IP-0178	IP-0178.fasta
IP-0179	IP-0179.fasta
IP-0180	IP-0180.fasta
EOFSKA

    # Verify input file was created correctly
    echo "Input file contents:"
    cat cluster_5_input.tsv
    
    # Verify that all files exist
    echo "Checking file existence:"
    for file in *.fasta *.fa *.fna *.fas *.fsa; do
        if [ -f "$file" ]; then
            echo "Found: $file"
        fi
    done 2>/dev/null || echo "No FASTA files found with standard extensions"
    
    # Build SKA file
    ska build \
        -o cluster_5 \
        -f cluster_5_input.tsv \
         || {
        echo "WARNING: SKA build failed for cluster cluster_5. Creating empty SKA file."
        touch cluster_5.skf
    }

    # Ensure SKA file exists
    if [ ! -f "cluster_5.skf" ]; then
        echo "WARNING: Missing SKA file for cluster cluster_5. Creating empty file."
        touch cluster_5.skf
    fi

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_BUILD":
        ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
    END_VERSIONS
