#!/bin/bash -euo pipefail
source bash_functions.sh

# Rename input files to prefix and move to inputfiles dir
mkdir inputfiles
cp GCF_000773235_1_Australia.fasta inputfiles/"GCF_000773235_1_Australia.fasta"

# gunzip all files that end in .{gz,Gz,GZ,gZ}
find -L inputfiles/ -type f -name '*.[gG][zZ]' -exec gunzip -f {} +

# Filter out small inputfiles
msg "Checking input file sizes.."
echo -e "Sample name	QC step	Outcome (Pass/Fail)" > "GCF_000773235_1_Australia.Initial_Input_File.tsv"
for file in inputfiles/*; do
  if verify_minimum_file_size "${file}" 'Input' "1k"; then
    echo -e "$(basename ${file%%.*})	Input File	PASS"         >> "GCF_000773235_1_Australia.Initial_Input_File.tsv"
  else
    echo -e "$(basename ${file%%.*})	Input File	FAIL"         >> "GCF_000773235_1_Australia.Initial_Input_File.tsv"

    rm ${file}
  fi
done

cat <<-END_VERSIONS > versions.yml
"ASSEMBLY_SNPS_SCALABLE:INFILE_HANDLING_UNIX":
  ubuntu: $(awk -F ' ' '{print $2,$3}' /etc/issue | tr -d '\n')
END_VERSIONS
