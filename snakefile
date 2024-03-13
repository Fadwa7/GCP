#!/bin/python3 
configfile: "config.json"
import re 
import csv 
import json
import subprocess
import os





print(r'   _____  _   _ ______  _____ __   __ ______  _____  _____  _   _ ______  _____  _____ ______ ')
print(r'  |_   _|| \ | ||  _  \|  ___|\ \ / / | ___ \|  ___||_   _|| \ | ||  _  \|  ___||  ___|| ___ \ ')
print(r'    | |  |  \| || | | || |__   \ V /  | |_/ /| |__    | |  |  \| || | | || |__  | |__  | |_/ / ')
print(r'    | |  | . ` || | | ||  __|  /   \  |    / |  __|   | |  | . ` || | | ||  __| |  __| |    / ')
print(r'   _| |_ | |\  || |/ / | |___ / /^\ \ | |\ \ | |___  _| |_ | |\  || |/ / | |___ | |___ | |\ \ ')
print(r'   \___/ \_| \_/|___/  \____/ \/   \/ \_| \_|\____/  \___/ \_| \_/|___/  \____/ \____/ \_| \_| ')
print(r'                                                                                                 ')
print(r'                                                                                                 ')



# Extraction of config file 

with open('config.json', 'r') as config_file:
        config = json.load(config_file)
fichier_csv = config.get("SRA_LIST")
if "SRA_LIST" in config:
        fichier_csv = config["SRA_LIST"]


SRA_LIST = []
with open(fichier_csv, 'rt') as f:
    for line in f:
        line = line.split()[0].strip()
        if re.match('[SED]RR\d+$', line): 
            SRA_LIST.append(line) 


if config['SAMPLE'] =="single":
	rule all : 
     		input: 
                         expand(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz", sra=SRA_LIST),
                         config["RESULTS"] + "QC/multiqc_report.html",
                         expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST),
                         config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz",
                         config["RESULTS"] + "Statistics/statistics.txt"

if config['SAMPLE'] =="paired":
	rule all : 
                input: 
                         expand(config["RESULTS"] + "Fastq_Files/{sra}_1.fastq.gz", sra=SRA_LIST),
                         expand(config["RESULTS"] + "Fastq_Files/{sra}_2.fastq.gz", sra=SRA_LIST),
                         config["RESULTS"] + "QC/multiqc_report.html",
                         expand(config["RESULTS"] + "Trimming/{sra}/{sra}_{reads}_cutadapt.fastq.gz", sra=SRA_LIST, reads=config["READS"]),
                         config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz",
                         config["RESULTS"] + "Statistics/statistics.txt"

          
##### Modules #####

include: "rules/fastq.smk"
include: "rules/multiqc.smk"
include: "rules/trimming.smk"
if config['SAMPLE'] =="single":
	include: "rules/bcalm_single.smk"
if config['SAMPLE'] =="paired":
	include: "rules/bcalm_paired.smk"
include: "rules/reindeer.smk"
include: "rules/statistics.smk"
##### End messages #####

onsuccess:
    print("Workflow finished, no error")

onerror:
    print("An error occurred")
