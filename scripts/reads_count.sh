#!/bin/bash

if [ $# -lt 1 ] ; then
    echo ""
    echo "usage: count_fastq.sh [fastq_file1] <fastq_file2> ..|| *.fastq.gz"
    echo "counts the number of reads in a fastq file"
    echo ""
    exit 0
fi

filear=${@};
for i in ${filear[@]}; do
    if [[ "$i" == *.gz ]]; then
        lines=$(zcat $i | wc -l | cut -d " " -f 1)
    else
        lines=$(wc -l $i | cut -d " " -f 1)
    fi

    count=$(($lines / 4))
    echo -n -e "\t$i : "
    echo "$count" | sed -r ':L;s=([0-9]+)([0-9]{3})=\1,\2=;t L'
done
