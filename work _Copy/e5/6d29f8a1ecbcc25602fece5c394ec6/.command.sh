#!/bin/bash -euo pipefail
# Install compatible versions of numpy and pandas
    pip install --upgrade numpy>=1.15.4
    pip install pandas biopython

    python3 << 'EOF'
import os
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import pandas as pd

def extract_core_snps(alignment_file, cluster_id, clusters_file):
    # Extract core SNP positions from cluster alignment
    
    # Read cluster assignments to get sample names
    clusters_df = pd.read_csv(clusters_file, sep='\t')
    cluster_samples = clusters_df[clusters_df['cluster_id'] == cluster_id]['sample_id'].tolist()
    
    # Read alignment
    sequences = {}
    for record in SeqIO.parse(alignment_file, "fasta"):
        sequences[record.id] = str(record.seq)
    
    if not sequences:
        print(f"Warning: No sequences found in alignment for cluster {cluster_id}")
        # Create empty files
        with open(f"{cluster_id}_core_snps.fa", 'w') as f:
            pass
        with open(f"{cluster_id}_snp_positions.tsv", 'w') as f:
            f.write("position\tref_base\talt_bases\tcluster_id\n")
        return
    
    # Get alignment length
    seq_names = list(sequences.keys())
    alignment_length = len(sequences[seq_names[0]])
    
    # Find variable positions (SNPs)
    snp_positions = []
    core_snps = {name: [] for name in seq_names}
    
    for pos in range(alignment_length):
        bases_at_pos = set()
        for name in seq_names:
            base = sequences[name][pos]
            if base not in ['-', 'N', 'n']:  # Exclude gaps and Ns
                bases_at_pos.add(base.upper())
        
        # If more than one base type at this position, it's a SNP
        if len(bases_at_pos) > 1:
            snp_positions.append({
                'position': pos + 1,  # 1-based position
                'ref_base': sorted(bases_at_pos)[0],  # Use first alphabetically as ref
                'alt_bases': ','.join(sorted(bases_at_pos)[1:]),
                'cluster_id': cluster_id
            })
            
            # Add this position to core SNPs for each sequence
            for name in seq_names:
                base = sequences[name][pos]
                core_snps[name].append(base.upper() if base not in ['-', 'N', 'n'] else 'N')
    
    # Write core SNPs FASTA
    with open(f"{cluster_id}_core_snps.fa", 'w') as f:
        for name in seq_names:
            if core_snps[name]:  # Only write if there are SNPs
                snp_seq = ''.join(core_snps[name])
                f.write(f">{name}\n{snp_seq}\n")
    
    # Write SNP positions table
    snp_df = pd.DataFrame(snp_positions)
    snp_df.to_csv(f"{cluster_id}_snp_positions.tsv", sep='\t', index=False)
    
    print(f"Cluster {cluster_id}: Found {len(snp_positions)} core SNP positions")

# Run extraction
extract_core_snps("cluster_4.filtered_polymorphic_sites.fasta", "cluster_4", "clusters.tsv")
EOF

    cat <<-END_VERSIONS > versions.yml
    "ASSEMBLY_SNPS_SCALABLE:INTEGRATE_RESULTS:EXTRACT_CORE_SNPS":
        python: $(python --version | sed 's/Python //')
        biopython: $(python -c "import Bio; print(Bio.__version__)")
        pandas: $(python -c "import pandas; print(pandas.__version__)")
        numpy: $(python -c "import numpy; print(numpy.__version__)")
    END_VERSIONS
