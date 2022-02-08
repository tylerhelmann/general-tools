#! /bin/bash

FILE=SraRunTable.txt

# Requires the SRA Toolkit in the PATH
# https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software
if ! [ -x "$(command -v fasterq-dump)" ]; then
  echo 'Error: fasterq-dump is not in the path.'
  exit 1
fi

# Check metadata file exists in working directory
if ! [ -f "$FILE" ]; then 
  echo 'Error: SraRunTable.txt not found.'
  exit 1
fi

mkdir -p sra_files

ALL_SRR=$(awk -F "\"*,\"*" '{print $1}' $FILE | sed 1d)

for SRR in $ALL_SRR; do

# fasterq-dump downloads unzipped files
SAMPLE_NAME=$(grep $SRR $FILE | awk -F "\"*,\"*" '{print $30}')

# Download all files from list
fasterq-dump $SRR -p -o sra_files/${SAMPLE_NAME}.fastq

done
