#!/bin/bash -euo pipefail
# Create input file for SKA
    cat > cluster_1_input.tsv <<'EOFSKA'
GCA_963565485_1	GCA_963565485_1.fasta
GCA_963565565_1	GCA_963565565_1.fasta
GCA_963566085_1	GCA_963566085_1.fasta
GCA_963566175_1	GCA_963566175_1.fasta
GCA_963566475_1	GCA_963566475_1.fasta
GCA_963566495_1	GCA_963566495_1.fasta
GCA_963566625_1	GCA_963566625_1.fasta
GCA_963566635_1	GCA_963566635_1.fasta
GCA_963566695_1	GCA_963566695_1.fasta
GCA_963566765_1	GCA_963566765_1.fasta
GCA_963566855_1	GCA_963566855_1.fasta
GCA_963567325_1	GCA_963567325_1.fasta
GCA_963567935_1	GCA_963567935_1.fasta
GCA_963568055_1	GCA_963568055_1.fasta
GCA_963568705_1	GCA_963568705_1.fasta
GCA_963568785_1	GCA_963568785_1.fasta
GCA_963568885_1	GCA_963568885_1.fasta
GCA_963569325_1	GCA_963569325_1.fasta
GCA_963569365_1	GCA_963569365_1.fasta
GCA_963569645_1	GCA_963569645_1.fasta
GCA_963569685_1	GCA_963569685_1.fasta
GCA_963569795_1	GCA_963569795_1.fasta
GCA_963570025_1	GCA_963570025_1.fasta
GCA_963570105_1	GCA_963570105_1.fasta
GCA_963570575_1	GCA_963570575_1.fasta
GCA_963571005_1	GCA_963571005_1.fasta
GCA_963571055_1	GCA_963571055_1.fasta
GCA_963571475_1	GCA_963571475_1.fasta
GCA_963571975_1	GCA_963571975_1.fasta
GCA_963572615_1	GCA_963572615_1.fasta
GCA_963573095_1	GCA_963573095_1.fasta
GCA_963573225_1	GCA_963573225_1.fasta
GCF_000773235_1_Australia	GCF_000773235_1_Australia.fasta
GCF_000774495_1_Australia	GCF_000774495_1_Australia.fasta
GCF_001207785_2_Malaysia	GCF_001207785_2_Malaysia.fasta
GCF_002110925_1_USA_Texas	GCF_002110925_1_USA_Texas.fasta
GCF_002110985_1_USA_Puerto_Rico	GCF_002110985_1_USA_Puerto_Rico.fasta
GCF_002111145_1_USA_Arizona_ex_Costa_Rica	GCF_002111145_1_USA_Arizona_ex_Costa_Rica.fasta
GCF_003268075_1_Viet_Nam	GCF_003268075_1_Viet_Nam.fasta
GCF_003268105_1_Viet_Nam	GCF_003268105_1_Viet_Nam.fasta
GCF_009827035_1_Viet_Nam	GCF_009827035_1_Viet_Nam.fasta
GCF_014712775_1_Laos	GCF_014712775_1_Laos.fasta
GCF_014712835_1_Laos	GCF_014712835_1_Laos.fasta
GCF_014712895_1_Laos	GCF_014712895_1_Laos.fasta
GCF_014712915_1_Laos	GCF_014712915_1_Laos.fasta
GCF_014712935_1_Laos	GCF_014712935_1_Laos.fasta
GCF_014712955_1_Laos	GCF_014712955_1_Laos.fasta
GCF_014713085_1_Laos	GCF_014713085_1_Laos.fasta
GCF_025847905_1_Viet_Nam	GCF_025847905_1_Viet_Nam.fasta
IE-0001	IE-0001.fasta
EOFSKA

    # Verify input file was created correctly
    echo "Input file contents:"
    cat cluster_1_input.tsv
    
    # Verify that all files exist
    echo "Checking file existence:"
    for file in *.fasta *.fa *.fna *.fas *.fsa; do
        if [ -f "$file" ]; then
            echo "Found: $file"
        fi
    done 2>/dev/null || echo "No FASTA files found with standard extensions"
    
    # Build SKA file
    ska build \
        -o cluster_1 \
        -f cluster_1_input.tsv \
         || {
        echo "WARNING: SKA build failed for cluster cluster_1. Creating empty SKA file."
        touch cluster_1.skf
    }

    # Ensure SKA file exists
    if [ ! -f "cluster_1.skf" ]; then
        echo "WARNING: Missing SKA file for cluster cluster_1. Creating empty file."
        touch cluster_1.skf
    fi

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:CLUSTERED_SNP_TREE:SKA_BUILD":
        ska: $(ska --version 2>&1 | head -n1 | sed 's/^/    /')
    END_VERSIONS
