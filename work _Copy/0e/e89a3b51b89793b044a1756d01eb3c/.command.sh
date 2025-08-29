#!/bin/bash -euo pipefail
# Create input file for SKA
    cat > cluster_0_input.tsv <<'EOFSKA'
ERS012303	ERS012303.fasta
ERS012306	ERS012306.fasta
ERS012307	ERS012307.fasta
ERS012309	ERS012309.fasta
ERS012312	ERS012312.fasta
ERS012313	ERS012313.fasta
ERS012316	ERS012316.fasta
ERS012320	ERS012320.fasta
ERS012330	ERS012330.fasta
ERS012332	ERS012332.fasta
ERS012358	ERS012358.fasta
ERS012362	ERS012362.fasta
ERS012363	ERS012363.fasta
ERS012365	ERS012365.fasta
ERS012370	ERS012370.fasta
ERS013343	ERS013343.fasta
ERS013346	ERS013346.fasta
ERS013348	ERS013348.fasta
ERS013352	ERS013352.fasta
ERS013354	ERS013354.fasta
ERS013364	ERS013364.fasta
GCA_963560585_1	GCA_963560585_1.fasta
GCA_963560675_1	GCA_963560675_1.fasta
GCA_963560735_1	GCA_963560735_1.fasta
GCA_963560915_1	GCA_963560915_1.fasta
GCA_963560945_1	GCA_963560945_1.fasta
GCA_963561075_1	GCA_963561075_1.fasta
GCA_963561215_1	GCA_963561215_1.fasta
GCA_963561435_1	GCA_963561435_1.fasta
GCA_963561835_1	GCA_963561835_1.fasta
GCA_963561855_1	GCA_963561855_1.fasta
GCA_963561915_1	GCA_963561915_1.fasta
GCA_963561975_1	GCA_963561975_1.fasta
GCA_963562615_1	GCA_963562615_1.fasta
GCA_963562655_1	GCA_963562655_1.fasta
GCA_963562695_1	GCA_963562695_1.fasta
GCA_963562795_1	GCA_963562795_1.fasta
GCA_963562965_1	GCA_963562965_1.fasta
GCA_963563065_1	GCA_963563065_1.fasta
GCA_963563155_1	GCA_963563155_1.fasta
GCA_963563475_1	GCA_963563475_1.fasta
GCA_963563525_1	GCA_963563525_1.fasta
GCA_963563635_1	GCA_963563635_1.fasta
GCA_963563715_1	GCA_963563715_1.fasta
GCA_963564305_1	GCA_963564305_1.fasta
GCA_963564375_1	GCA_963564375_1.fasta
GCA_963564975_1	GCA_963564975_1.fasta
GCA_963565015_1	GCA_963565015_1.fasta
GCA_963565125_1	GCA_963565125_1.fasta
GCA_963565395_1	GCA_963565395_1.fasta
EOFSKA

    # Verify input file was created correctly
    echo "Input file contents:"
    cat cluster_0_input.tsv
    
    # Verify that all files exist
    echo "Checking file existence:"
    for file in *.fasta *.fa *.fna *.fas *.fsa; do
        if [ -f "$file" ]; then
            echo "Found: $file"
        fi
    done 2>/dev/null || echo "No FASTA files found with standard extensions"
    
    # Build SKA file
    ska build \
        -o cluster_0 \
        -f cluster_0_input.tsv \
         || {
        echo "WARNING: SKA build failed for cluster cluster_0. Creating empty SKA file."
        touch cluster_0.skf
    }

    # Ensure SKA file exists
    if [ ! -f "cluster_0.skf" ]; then
        echo "WARNING: Missing SKA file for cluster cluster_0. Creating empty file."
        touch cluster_0.skf
    fi

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_BUILD":
        ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
    END_VERSIONS
