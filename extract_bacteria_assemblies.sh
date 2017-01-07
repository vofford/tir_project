#! /bin/bash

CATEGORIES=categories.dmp
GENOMES=assembly_summary_genbank.txt
TXID=unique_txid.txt
OUTFILE=bacteria_only_assembly_summary_genbank.txt

awk '($1 == "B"){print $2}' categories.dmp | sort | uniq > $TXID
awk ' BEGIN { 
		FS="\t";
        OFS="\t";

		while (getline < "'"$TXID"'") 
		{ 
			list[$0]=1; 
		} 
		close("'"$TXID"'"); 

		while (getline < "'"$GENOMES"'") 
		{ 
			split($0,ln,"\t");
			tid=ln[7]
			if (list[tid] == 1) 
			{
                protein=$20 "/" $1 "_" $16 "_protein.faa.gz"
                gsub(/ /,"_",protein)
				print $0,protein
			} 
		} 
		close("'"$GENOMES"'");	
	}' > $OUTFILE