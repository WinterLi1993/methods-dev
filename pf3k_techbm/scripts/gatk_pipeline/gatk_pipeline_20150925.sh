#!/bin/bash

################################################################################
# Introduction
################################################################################
# This should do a "manual" run (as opposed to a vr-pipe run) of the Pf3k
# pipeline on the 5 validation samples

# To run (ideally using screen):
# cd $HOME/src/github/malariagen/methods-dev/pf3k_techbm/scripts/gatk_pipeline
# $HOME/src/github/malariagen/methods-dev/pf3k_techbm/scripts/gatk_pipeline/gatk_pipeline_20150925.sh >> $HOME/src/github/malariagen/methods-dev/pf3k_techbm/log/gatk_pipeline_20150925.log


################################################################################
# Pre requisities
################################################################################
# 
# If installing GATK, this must be downloaded manually from
# https://www.broadinstitute.org/gatk/download/auth?package=GATK and put in home
# directory. This can't be downloaded automatically using wget.



################################################################################
# Set up envirnoment variables
################################################################################

# catch errors
# set -e
# set -o pipefail


[ -z "$PIPELINE_NAME" ] && PIPELINE_NAME="alistair_ann"
[ -z "$MAPPING_DIR" ] && MAPPING_DIR="bwa_mem"
[ -z "$BAMS_DIR" ] && BAMS_DIR="gatk_rec"
[ -z "$UNFILTERED_DIR" ] && UNFILTERED_DIR="HaplotypeCaller"
[ -z "$FILTERED_DIR" ] && FILTERED_DIR="alistair_ann"
[ -z "$ANNOTATED_DIR" ] && ANNOTATED_DIR="SnpEff_region"
[ -z "$VQSR_ANNOTATIONS_SNP" ] && VQSR_ANNOTATIONS_SNP="-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP"
[ -z "$VQSR_ANNOTATIONS_INDEL" ] && VQSR_ANNOTATIONS_INDEL="-an QD -an DP -an MQ -an FS -an BaseQRankSum"
[ -z "$MAX_GAUSSIANS_SNP" ] && MAX_GAUSSIANS_SNP="8"
[ -z "$MAX_GAUSSIANS_INDEL" ] && MAX_GAUSSIANS_INDEL="4"
[ -z "$VQSR_TRAINING" ] && VQSR_PRIOR="crosses"
[ -z "$VQSR_PRIOR" ] && VQSR_PRIOR="15"

echo ${VQSR_ANNOTATIONS_SNP}
echo ${VQSR_ANNOTATIONS_INDEL}

# directories
export ORIGINAL_DIR=`pwd`
export PROCESSED_DATA_DIR="/lustre/scratch110/malaria/rp7/Pf3k/GATKbuild/validation_results"
export TEMP_DIR="/lustre/scratch110/malaria/rp7/Pf3k/GATKbuild/tmp"
export REF_GENOME_DIR="/lustre/scratch110/malaria/rp7/Pf3k/GATKbuild/Pfalciparum_GeneDB_Aug2015"
export OPT_DIR="$HOME/src/github/malariagen/methods-dev/pf3k_techbm/opt_4"
# export PROCESSED_DATA_DIR="/nfs/team112_internal/production_files/Pf3k/methods/GATKbuild/assembled_samples"
# export REF_GENOME_DIR="/nfs/team112_internal/production_files/Pf3k/methods/GATKbuild/Pf3D7_GeneDB"
# export OPT_DIR="$HOME/src/github/malariagen/methods-dev/pf3k_techbm/opt"
export SNPEFF_DIR="${OPT_DIR}/snpeff/snpEff"
export CROSSES_DIR="/nfs/team112_internal/oxford_mirror/data/plasmodium/pfalciparum/pf-crosses/data/public/1.0"
export CORTEX_VALIDATION_DIR="/lustre/scratch110/malaria/rp7/Pf3k/GATKbuild/validation_cortex/raw_cortex_20150915"

# parameters
export MAX_ALTERNATE_ALLELES=6
export GVCF_BATCH_SIZE=3
# export VQSR_ANNOTATIONS_SNP="-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP"
# export VQSR_ANNOTATIONS_INDEL="-an QD -an DP -an FS -an SOR -an ReadPosRankSum -an MQRankSum"
# export MAX_GAUSSIANS_SNP=8
# export MAX_GAUSSIANS_INDEL=4

# manifests
export SAMPLE_MANIFEST="$HOME/src/github/malariagen/methods-dev/pf3k_techbm/meta/validation_sample_bams.txt"
# export SHUFFLED_SAMPLE_MANIFEST="$HOME/src/github/malariagen/methods-dev/pf3k_techbm/meta/validation_sample_bams_shuffled.txt"

# reference genome
export REF_GENOME_DATE="2015-08"
# export REF_GENOME_FASTA_URL="http://www.plasmodb.org/common/downloads/release-25/Pfalciparum3D7/fasta/data/PlasmoDB-25_Pfalciparum3D7_Genome.fasta"
export REF_GENOME_FASTA_URL="ftp://ftp.sanger.ac.uk/pub/project/pathogens/gff3/${REF_GENOME_DATE}/Pfalciparum.genome.fasta.gz"
export REF_GENOME_GFF_URL="ftp://ftp.sanger.ac.uk/pub/project/pathogens/gff3/${REF_GENOME_DATE}/Pfalciparum.gff3.gz"
# export APICOPLAST_REF_GENOME_FASTA="/nfs/pathogen003/tdo/Pfalciparum/3D7/Reference/Oct2011/Pf3D7_v3.fasta"
# export APICOPLAST_SEQUENCE_NAME="PF_apicoplast_genome_1"
export SNPEFF_DB="Pfalciparum_GeneDB_Aug2015"
export SNPEFF_CONFIG_FN="${SNPEFF_DIR}/snpEff.config"

# data files
export REF_GENOME="${REF_GENOME_DIR}/Pfalciparum.genome.fasta"
export REF_GENOME_INDEX="${REF_GENOME_DIR}/Pfalciparum.genome.fasta.fai"
export REF_GENOME_DICTIONARY="${REF_GENOME_DIR}/Pfalciparum.genome.dict"
# export REF_GENOME="/nfs/team112_internal/production_files/Pf3k/methods/GATKbuild/roamato/Pf3D7_v3/3D7_sorted.fa"
# export REF_GENOME_INDEX="/nfs/team112_internal/production_files/Pf3k/methods/GATKbuild/roamato/Pf3D7_v3/3D7_sorted.fa.fai"
export REGIONS_FN="$HOME/src/github/malariagen/pf-crosses/meta/regions-20130225.bed.gz"

# software versions
export PICARD_VERSION="1.137"
export BWA_VERSION="0.7.12"
export SAMTOOLS_VERSION="1.2"
export GATK_VERSION="3.4-46"
export VCFTOOLS_VERSION="0.1.10"
export SNPEFF_VERSION="4_1i"
# export VCFTOOLS_VERSION="0.1.12b"

# executables
export JAVA7_EXE="/software/jre1.7.0_25/bin/java"
export SAMTOOLS_EXE="${OPT_DIR}/samtools/samtools-${SAMTOOLS_VERSION}/samtools"
export PICARD_EXE="${JAVA7_EXE} -jar ${OPT_DIR}/picard/picard-tools-${PICARD_VERSION}/picard.jar"
export SNPEFF_EXE="${JAVA7_EXE} -jar ${SNPEFF_DIR}/snpEff.jar"
# export SNPEFF_EXE="${JAVA7_EXE} -jar /nfs/team112_internal/production/tools/bin/snpEff_4_1/snpEff.jar"
export BWA_EXE="${OPT_DIR}/bwa/bwa-${BWA_VERSION}/bwa"
export GATK_EXE="${JAVA7_EXE} -jar ${OPT_DIR}/gatk/GenomeAnalysisTK.jar"
export FIRST_LAST_100BP_EXE="python $HOME/src/github/malariagen/methods-dev/pf3k_techbm/scripts/gatk_pipeline/first_last_100bp.py"
export VCF_ANNOTATE_EXE="${OPT_DIR}/vcftools/vcftools_${VCFTOOLS_VERSION}/perl/vcf-annotate"

number_of_samples=$(wc -l < ${SAMPLE_MANIFEST})
number_of_chromosomes=$(wc -l < ${REF_GENOME_INDEX})


################################################################################
# Functions
################################################################################

get_RG () {
    $SAMTOOLS_EXE view -H "$1" | grep '^@RG'
}



################################################################################
# Install software
################################################################################

# Install picard
if [ ! -s ${OPT_DIR}/picard/picard-tools-${PICARD_VERSION}/picard.jar ]; then
    mkdir -p ${OPT_DIR}/picard
    cd ${OPT_DIR}/picard
    wget https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard-tools-${PICARD_VERSION}.zip
    unzip picard-tools-${PICARD_VERSION}.zip
    cd ${ORIGINAL_DIR}
fi

# Install SnpEff
if [ ! -s ${SNPEFF_DIR}/snpEff.jar ]; then
    mkdir -p ${OPT_DIR}/snpeff
    cd ${OPT_DIR}/snpeff
    wget http://downloads.sourceforge.net/project/snpeff/snpEff_v${SNPEFF_VERSION}_core.zip
    unzip snpEff_v${SNPEFF_VERSION}_core.zip
    cd ${ORIGINAL_DIR}
fi

# Install bwa
if [ ! -s ${BWA_EXE} ]; then
    mkdir -p ${OPT_DIR}/bwa
    cd ${OPT_DIR}/bwa
    wget http://downloads.sourceforge.net/project/bio-bwa/bwa-${BWA_VERSION}.tar.bz2
    tar -xf bwa-${BWA_VERSION}.tar.bz2
    cd bwa-${BWA_VERSION}
    make 2> /dev/null
    cd ${ORIGINAL_DIR}
fi

# Install samtools
if [ ! -s ${SAMTOOLS_EXE} ]; then
    mkdir -p ${OPT_DIR}/samtools
    cd ${OPT_DIR}/samtools
    wget http://downloads.sourceforge.net/project/samtools/samtools/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
    tar xjf samtools-${SAMTOOLS_VERSION}.tar.bz2
    cd samtools-${SAMTOOLS_VERSION}
    make 2> /dev/null
    cd ${ORIGINAL_DIR}
fi

# Install GATK
if [ ! -s ${OPT_DIR}/gatk/GenomeAnalysisTK.jar ]; then
    mkdir -p ${OPT_DIR}/gatk
    cp ~/GenomeAnalysisTK-${GATK_VERSION}.tar.bz2 ${OPT_DIR}/gatk
    cd ${OPT_DIR}/gatk
    tar xjf GenomeAnalysisTK-${GATK_VERSION}.tar.bz2
    cd ${ORIGINAL_DIR}
fi

# Install VCFtools
export PERL5LIB=${OPT_DIR}/vcftools/vcftools_${VCFTOOLS_VERSION}/perl/
if [ ! -s ${VCF_ANNOTATE_EXE} ]; then
    mkdir -p ${OPT_DIR}/vcftools
    cd ${OPT_DIR}/vcftools
    wget http://downloads.sourceforge.net/project/vcftools/vcftools_${VCFTOOLS_VERSION}.tar.gz
    tar xzf vcftools_${VCFTOOLS_VERSION}.tar.gz
    cd vcftools_${VCFTOOLS_VERSION}
    make 2> /dev/null
    cd ${ORIGINAL_DIR}
fi




################################################################################
# Download reference and create SnpEff database
################################################################################

if [ ! -d "${REF_GENOME_DIR}" ]; then
    mkdir -p "${REF_GENOME_DIR}"
fi

# sed -n '/>PF_apicoplast_genome_1/,$ p' /nfs/pathogen003/tdo/Pfalciparum/3D7/Reference/Oct2011/Pf3D7_v3.fasta

if [ ! -s ${REF_GENOME} ]; then
    wget ${REF_GENOME_FASTA_URL} -O ${REF_GENOME}.gz
    gunzip ${REF_GENOME}.gz
    # sed -n '/>PF_apicoplast_genome_1/,$ p' ${APICOPLAST_REF_GENOME_FASTA} >> ${REF_GENOME}
fi

# if [ ! -s ${REF_GENOME} ]; then
#     wget ${REF_GENOME_FASTA_URL} -O ${REF_GENOME}.gz
#     gunzip ${REF_GENOME}.gz
#     sed -n '/>PF_apicoplast_genome_1/,$ p' ${APICOPLAST_REF_GENOME_FASTA} >> ${REF_GENOME}
# fi
#
# Generate BWA index
if [ ! -s ${REF_GENOME}.bwt ] || [ ! -s ${REF_GENOME}.pac ] || [ ! -s ${REF_GENOME}.ann ] || [ ! -s ${REF_GENOME}.amb ] || [ ! -s ${REF_GENOME}.sa ]; then
    $BWA_EXE index ${REF_GENOME}
fi

# Generate samtools index
if [ ! -s ${REF_GENOME}.fai ]; then
    $SAMTOOLS_EXE faidx ${REF_GENOME}
fi

# Generate sequence dictionary
if [ ! -s ${REF_GENOME_DICTIONARY} ]; then
    $PICARD_EXE CreateSequenceDictionary \
    REFERENCE=${REF_GENOME} \
    OUTPUT=${REF_GENOME_DICTIONARY}
fi

# Make directory for SnpEff database
if [ ! -d "${SNPEFF_DIR}/data/${SNPEFF_DB}" ]; then
    mkdir -p ${SNPEFF_DIR}/data/${SNPEFF_DB}
fi

# Put appropriate gff in SnpEff database directory
if [ ! -s "${SNPEFF_DIR}/data/${SNPEFF_DB}/genes.gff" ]; then
    gff_download_date=`date`
    wget ${REF_GENOME_GFF_URL} -O "${SNPEFF_DIR}/data/${SNPEFF_DB}/genes.gff.gz"
    gunzip "${SNPEFF_DIR}/data/${SNPEFF_DB}/genes.gff.gz"
fi

# Put appropriate fasta in SnpEff database directory
if [ ! -s "${SNPEFF_DIR}/data/${SNPEFF_DB}/sequences.fa" ]; then
    cp ${REF_GENOME} "${SNPEFF_DIR}/data/${SNPEFF_DB}/sequences.fa"
fi

# Update SnpEff config file with appropriate lines
if [ `grep ${SNPEFF_DB} ${SNPEFF_CONFIG_FN} | wc -l` == 0 ]; then
    echo "" >> ${SNPEFF_CONFIG_FN}
    echo "#" ${SNPEFF_DB} "downloaded from" ${REF_GENOME_GFF_URL} ${gff_download_date} >> ${SNPEFF_CONFIG_FN}
    echo ${SNPEFF_DB}".genome: Plasmodium_falciparum" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".Pf_M76611.codonTable: Protozoan_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".reference: "${REF_GENOME_GFF_URL} >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".mal_mito_1.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".mal_mito_2.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".mal_mito_3.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_10\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_15\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_16\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_17\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".mal_mito_RNA19\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_1\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_20\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_21\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_9\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_LSUC\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_LSUF\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_LSUG\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA11\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA12\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA14\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA18\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA22\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA4\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA5\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA6\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_RNA7\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_rna_SSUF\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
    echo "        "${SNPEFF_DB}".malmito_SSUB\:rRNA.codonTable : Vertebrate_Mitochondrial" >> ${SNPEFF_CONFIG_FN}
fi

if [ ! -s "${SNPEFF_DIR}/data/${SNPEFF_DB}/snpEffectPredictor.bin" ]; then
    $SNPEFF_EXE build -gff3 -v ${SNPEFF_DB}
fi



################################################################################
# Create data directories
################################################################################

directories=( \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/_sams" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_final_bams" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/samples" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/lists" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/combined_gvcf" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_unfiltered_vcfs" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_filtered_vcfs" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files" \
"${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_final_vcfs" \
"${TEMP_DIR}" \
)
# "${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/unfiltered" \

for directory in "${directories[@]}"
do
    if [ ! -d "$directory" ]; then
        
        mkdir -p "$directory"
    fi
done



################################################################################
# Run pipeline
################################################################################

# Remap with bwa mem, including subsetting 250bp reads to 100bp and converting cram
for (( i=1; i<=${number_of_samples}; i++ ));
do
    sample_name=`awk "NR==$i" ${SAMPLE_MANIFEST} | cut -f1`
    original_bam_fn=`awk "NR==$i" ${SAMPLE_MANIFEST} | cut -f2`
    bwa_mem_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/_sams/${sample_name}.bwa_mem.sam"
    read_group_info=`get_RG "${original_bam_fn}" | sed 's/\t/\\\\t/g'`
    if [ ! -s ${bwa_mem_fn} ]; then
        if [[ "${original_bam_fn}" == *.bam ]]; then
            ${SAMTOOLS_EXE} bamshuf -uOn 128 "${original_bam_fn}" tmp | \
            ${SAMTOOLS_EXE} bam2fq - | \
            ${BWA_EXE} mem -M -R "${read_group_info}" -p ${REF_GENOME} - > ${bwa_mem_fn} 2> /dev/null
        elif [[ "${original_bam_fn}" == *.cram ]]; then
            ${SAMTOOLS_EXE} view -b "${original_bam_fn}" | \
            ${SAMTOOLS_EXE} bamshuf -uOn 128 - tmp | \
            ${SAMTOOLS_EXE} bam2fq - | \
            ${FIRST_LAST_100BP_EXE} - | \
            ${BWA_EXE} mem -M -R "${read_group_info}" -p ${REF_GENOME} - > ${bwa_mem_fn} 2> /dev/null
        fi
    fi
done


# Sort and mark duplicates
for (( i=1; i<=${number_of_samples}; i++ ));
do
    sample_name=`awk "NR==$i" ${SAMPLE_MANIFEST} | cut -f1`
    bwa_mem_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.sam"
    sorted_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.sorted.bam"
    dedup_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.dedup.bam"
    dedup_index_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.dedup.bai"
    dedup_metrics_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.dedup.metrics"
    if [ ! -s ${sorted_fn} ]; then
        ${PICARD_EXE} SortSam \
            INPUT=${bwa_mem_fn} \
            OUTPUT=${sorted_fn} \
            SORT_ORDER=coordinate \
            TMP_DIR=${TEMP_DIR} #2> /dev/null
    fi
    if [ ! -s ${dedup_fn} ]; then
        ${PICARD_EXE} MarkDuplicates \
            INPUT=${sorted_fn} \
            OUTPUT=${dedup_fn} \
            METRICS_FILE=${dedup_metrics_fn} \
            TMP_DIR=${TEMP_DIR} #2> /dev/null#2> /dev/null
    fi
    if [ ! -s ${dedup_index_fn} ]; then
        ${PICARD_EXE} BuildBamIndex \
            INPUT=${dedup_fn} \
            TMP_DIR=${TEMP_DIR} #2> /dev/null#2> /dev/null
    fi
done


# Indel realignment
for (( i=1; i<=${number_of_samples}; i++ ));
do
    sample_name=`awk "NR==$i" ${SAMPLE_MANIFEST} | cut -f1`
    dedup_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.dedup.bam"
    targets_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.dedup.targets.list"
    realigned_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.realigned.bam"
    if [ ! -s ${targets_fn} ]; then
        ${GATK_EXE} \
            -T RealignerTargetCreator \
            -R ${REF_GENOME} \
            -I ${dedup_fn} \
            -o ${targets_fn} 2> /dev/null
    fi
    if [ ! -s ${realigned_fn} ]; then
        ${GATK_EXE} \
            -T IndelRealigner \
            -R ${REF_GENOME} \
            -I ${dedup_fn} \
            -targetIntervals ${targets_fn} \
            -o ${realigned_fn} 2> /dev/null
    fi
done


# Base quality score recalibration (BQSR)
for (( i=1; i<=${number_of_samples}; i++ ));
do
    sample_name=`awk "NR==$i" ${SAMPLE_MANIFEST} | cut -f1`
    realigned_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_intermediate_files/${sample_name}.bwa_mem.realigned.bam"
    recal_table_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_final_bams/${sample_name}.bwa_mem.recal.table"
    post_recal_table_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_final_bams/${sample_name}.bwa_mem.post_recal.table"
    recal_plots_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_final_bams/${sample_name}.bwa_mem.recal.pdf"
    recal_bam_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_final_bams/${sample_name}.bwa_mem.recal.bam"
    if [ ! -s ${recal_table_fn} ]; then
        ${GATK_EXE} \
            -T BaseRecalibrator \
            -R ${REF_GENOME} \
            -I ${realigned_fn} \
            -knownSites ${CROSSES_DIR}/7g8_gb4.combined.final.vcf.gz \
            -knownSites ${CROSSES_DIR}/hb3_dd2.combined.final.vcf.gz \
            -knownSites ${CROSSES_DIR}/3d7_hb3.combined.final.vcf.gz \
            -o ${recal_table_fn} 2> /dev/null
    fi
    # Note the following is in recommended best practices, but makes no difference to 
    # if [ ! -s ${post_recal_table_fn} ]; then
    #     ${GATK_EXE} \
    #         -T BaseRecalibrator \
    #         -R ${REF_GENOME} \
    #         -I ${realigned_fn} \
    #         -knownSites ${CROSSES_DIR}/7g8_gb4.combined.final.vcf.gz \
    #         -knownSites ${CROSSES_DIR}/hb3_dd2.combined.final.vcf.gz \
    #         -knownSites ${CROSSES_DIR}/3d7_hb3.combined.final.vcf.gz \
    #         -BQSR ${recal_table_fn} \
    #         -o ${post_recal_table_fn} 2> /dev/null
    # fi
    # if [ ! -s ${recal_plots_fn} ]; then
    #     ${GATK_EXE} \
    #         -T AnalyzeCovariates \
    #         -R ${REF_GENOME} \
    #         -before ${recal_table_fn} \
    #         -after ${post_recal_table_fn} \
    #         -plots ${recal_plots_fn} 2> /dev/null
    # fi
    if [ ! -s ${recal_bam_fn} ]; then
        ${GATK_EXE} \
            -T PrintReads \
            -R ${REF_GENOME} \
            -I ${realigned_fn} \
            -BQSR ${recal_table_fn} \
            -o ${recal_bam_fn} 2> /dev/null
    fi
done


# Haplotype Caller
for (( i=1; i<=${number_of_samples}; i++ ));
do
    sample_name=`awk "NR==$i" ${SAMPLE_MANIFEST} | cut -f1`
    recal_bam_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/_final_bams/${sample_name}.bwa_mem.recal.bam"
    gvcf_filestem="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/samples/${sample_name}.raw.snps.indels"
    for (( j=1; j<=${number_of_chromosomes}; j++ ));
    do
        chromosome=`awk "NR==$j" ${REF_GENOME_INDEX} | cut -f1`
        gvcf_fn=${gvcf_filestem}.${chromosome}.g.vcf
        if [ ! -s ${gvcf_fn} ]; then
            ${GATK_EXE} \
                -T HaplotypeCaller \
                -R ${REF_GENOME} \
                -I ${recal_bam_fn} \
                -L ${chromosome} \
                --emitRefConfidence GVCF \
                --variant_index_type LINEAR \
                --variant_index_parameter 128000 \
                --max_alternate_alleles ${MAX_ALTERNATE_ALLELES} \
                -o ${gvcf_fn} 2> /dev/null
             # --annotation HomopolymerRun \
             # --annotation VariantType \
        fi
    done
done


# Combine and genotype GVCFs
for (( chromosome_index=1; chromosome_index<=${number_of_chromosomes}; chromosome_index++ ));
do
    chromosome=`awk "NR==$chromosome_index" ${REF_GENOME_INDEX} | cut -f1`
    combined_gvcf_list_filename="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/lists/gvcfs.${chromosome}.all.list"
    if [ -f ${combined_gvcf_list_filename} ]; then
        rm ${combined_gvcf_list_filename}
    fi
    genotyped_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/raw_vcf/raw.snps.indels.${chromosome}.vcf"
    unfiltered_snp_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_unfiltered_vcfs/unfiltered.SNP.${chromosome}.vcf"
    unfiltered_indel_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_unfiltered_vcfs/unfiltered.INDEL.${chromosome}.vcf"
    batch_index=1
    position_in_batch=0
    for (( sample_index=1; sample_index<=${number_of_samples}; sample_index++ ));
    do
        position_in_batch=$((${position_in_batch}+1))
        if [ ${position_in_batch} -gt ${GVCF_BATCH_SIZE} ]; then
            position_in_batch=1
            batch_index=$((${batch_index}+1))
        fi
        if [ ${position_in_batch} == 1 ]; then
            gvcf_list_filename="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/lists/gvcfs.${chromosome}.${batch_index}.list"
            if [ -f ${gvcf_list_filename} ]; then
                rm ${gvcf_list_filename}
            fi
            combined_gvcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/combined_gvcf/combined.${chromosome}.${batch_index}.g.vcf"
            touch ${combined_gvcf_list_filename}
            echo ${combined_gvcf_fn} >> ${combined_gvcf_list_filename}
        fi
        sample_name=`awk "NR==$sample_index" ${SAMPLE_MANIFEST} | cut -f1`
        gvcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/samples/${sample_name}.raw.snps.indels.${chromosome}.g.vcf"
        touch ${gvcf_list_filename}
        echo ${gvcf_fn} >> ${gvcf_list_filename}
        # echo ${position_in_batch} ${GVCF_BATCH_SIZE} ${sample_index} ${number_of_samples}
        if [ ${position_in_batch} == ${GVCF_BATCH_SIZE} ] || [ ${sample_index} == ${number_of_samples} ]; then
            if [ ! -s ${combined_gvcf_fn} ]; then
                ${GATK_EXE} \
                    -T CombineGVCFs \
                    -R ${REF_GENOME} \
                    --variant ${gvcf_list_filename} \
                    -o ${combined_gvcf_fn} 2> /dev/null
            fi
        fi
    done
    if [ ! -s ${genotyped_vcf_fn} ]; then
        ${GATK_EXE} \
            -T GenotypeGVCFs \
            -R ${REF_GENOME} \
            --variant ${combined_gvcf_list_filename} \
            --max_alternate_alleles ${MAX_ALTERNATE_ALLELES} \
            --annotation QualByDepth \
            --annotation FisherStrand \
            --annotation StrandOddsRatio \
            --annotation VariantType \
            --annotation GCContent \
            --annotation TandemRepeatAnnotator \
            -o ${genotyped_vcf_fn} > /dev/null
        # Note that the HomopolymerRun is no longer supported and causes GenotypeGVCFs to crash
        # --annotation HomopolymerRun \
    fi
    if [ ! -s ${unfiltered_snp_vcf_fn} ]; then
        ${GATK_EXE} \
            -T SelectVariants \
            -R ${REF_GENOME} \
            -V ${genotyped_vcf_fn} \
            -selectType SNP \
            -o ${unfiltered_snp_vcf_fn} 2> /dev/null
    fi
    if [ ! -s ${unfiltered_indel_vcf_fn} ]; then
        ${GATK_EXE} \
            -T SelectVariants \
            -R ${REF_GENOME} \
            -V ${genotyped_vcf_fn} \
            -xlSelectType SNP  \
            -o ${unfiltered_indel_vcf_fn} 2> /dev/null
    fi
done


# Train VQSR
chromosome=`awk "NR==1" ${REF_GENOME_INDEX} | cut -f1`
genotyped_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/raw_vcf/raw.snps.indels.${chromosome}.vcf"
input_line="-input ${genotyped_vcf_fn}"
for (( chromosome_index=2; chromosome_index<=${number_of_chromosomes}; chromosome_index++ ));
do
    chromosome=`awk "NR==$chromosome_index" ${REF_GENOME_INDEX} | cut -f1`
    genotyped_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_intermediate_files/raw_vcf/raw.snps.indels.${chromosome}.vcf"
    input_line="${input_line} -input ${genotyped_vcf_fn}"
done

recal_snp_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_SNP.recal"
tranches_snp_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_SNP.tranches"
if [ ! -s ${recal_snp_fn} ]; then
    if [ $VQSR_TRAINING = "cortex" ]; then
        ${GATK_EXE} \
            -T VariantRecalibrator \
            -R ${REF_GENOME} \
            ${input_line} \
            -resource\:7G8,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/7G8_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:GB4,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/GB4_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:KE01,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/KE01_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:KH02,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/KH02_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:GN01,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/GN01_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            ${VQSR_ANNOTATIONS_SNP} \
            --maxGaussians ${MAX_GAUSSIANS_SNP} \
            -mode SNP \
            -recalFile ${recal_snp_fn} \
            -tranchesFile ${tranches_snp_fn}
        # 2> /dev/null
    else
        ${GATK_EXE} \
            -T VariantRecalibrator \
            -R ${REF_GENOME} \
            ${input_line} \
            -resource\:7g8_gb4,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CROSSES_DIR}/7g8_gb4.combined.final.vcf.gz \
            -resource\:hb3_dd2,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CROSSES_DIR}/hb3_dd2.combined.final.vcf.gz \
            -resource\:3d7_hb3,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CROSSES_DIR}/3d7_hb3.combined.final.vcf.gz \
            ${VQSR_ANNOTATIONS_SNP} \
            --maxGaussians ${MAX_GAUSSIANS_SNP} \
            -mode SNP \
            -recalFile ${recal_snp_fn} \
            -tranchesFile ${tranches_snp_fn} 2> /dev/null
    fi
fi

recal_indel_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_INDEL.recal"
tranches_indel_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_INDEL.tranches"
if [ ! -s ${recal_indel_fn} ]; then
    if [ $VQSR_TRAINING = "cortex" ]; then
        ${GATK_EXE} \
            -T VariantRecalibrator \
            -R ${REF_GENOME} \
            ${input_line} \
            -resource\:7G8,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/7G8_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:GB4,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/GB4_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:KE01,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/KE01_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:KH02,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/KH02_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            -resource\:GN01,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CORTEX_VALIDATION_DIR}/GN01_wk_flow_I_RefCC_FINALcombined_BC_calls_at_all_k.raw.vcf \
            ${VQSR_ANNOTATIONS_INDEL} \
            --maxGaussians ${MAX_GAUSSIANS_INDEL} \
            -mode INDEL \
            -recalFile ${recal_indel_fn} \
            -tranchesFile ${tranches_indel_fn}
        # 2> /dev/null
    else
        ${GATK_EXE} \
            -T VariantRecalibrator \
            -R ${REF_GENOME} \
            ${input_line} \
            -resource\:7g8_gb4,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CROSSES_DIR}/7g8_gb4.combined.final.vcf.gz \
            -resource\:hb3_dd2,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CROSSES_DIR}/hb3_dd2.combined.final.vcf.gz \
            -resource\:3d7_hb3,known=false,training=true,truth=true,prior=${VQSR_PRIOR} ${CROSSES_DIR}/3d7_hb3.combined.final.vcf.gz \
            ${VQSR_ANNOTATIONS_INDEL} \
            --maxGaussians ${MAX_GAUSSIANS_INDEL} \
            -mode INDEL \
            -recalFile ${recal_indel_fn} \
            -tranchesFile ${tranches_indel_fn} 2> /dev/null
    fi
fi


# Apply VQSR
for (( chromosome_index=1; chromosome_index<=${number_of_chromosomes}; chromosome_index++ ));
do
    chromosome=`awk "NR==$chromosome_index" ${REF_GENOME_INDEX} | cut -f1`
    # genotyped_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_unfiltered_vcfs/raw.snps.indels.${chromosome}.vcf"
    unfiltered_snp_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_unfiltered_vcfs/unfiltered.SNP.${chromosome}.vcf"
    unfiltered_indel_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/_unfiltered_vcfs/unfiltered.INDEL.${chromosome}.vcf"
    filtered_snp_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_filtered_vcfs/filtered.SNP.${chromosome}.vcf"
    filtered_indel_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_filtered_vcfs/filtered.INDEL.${chromosome}.vcf"
    # recal_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_SNP.recal"
    # tranches_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_SNP.tranches"
    if [ ! -s ${filtered_snp_vcf_fn}.gz ]; then
        ${GATK_EXE} \
            -T ApplyRecalibration \
            -R ${REF_GENOME} \
            -input ${unfiltered_snp_vcf_fn} \
            -tranchesFile ${tranches_snp_fn} \
            -recalFile ${recal_snp_fn} \
            --ts_filter_level 99.5 \
            -mode SNP \
            -o ${filtered_snp_vcf_fn} 2> /dev/null
        bgzip -f ${filtered_snp_vcf_fn}
        tabix -p vcf -f ${filtered_snp_vcf_fn}.gz
    fi
    # unfiltered_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/unfiltered/unfiltered.INDEL.${chromosome}.vcf"
    # filtered_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_filtered_vcfs/filtered.INDEL.${chromosome}.vcf"
    # recal_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_INDEL.recal"
    # tranches_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_intermediate_files/recal/recalibrate_INDEL.tranches"
    if [ ! -s ${filtered_indel_vcf_fn}.gz ]; then
        ${GATK_EXE} \
            -T ApplyRecalibration \
            -R ${REF_GENOME} \
            -input ${unfiltered_indel_vcf_fn} \
            -tranchesFile ${tranches_indel_fn} \
            -recalFile ${recal_indel_fn} \
            --ts_filter_level 99.0 \
            -mode INDEL \
            -o ${filtered_indel_vcf_fn} 2> /dev/null
        bgzip -f ${filtered_indel_vcf_fn}
        tabix -p vcf -f ${filtered_indel_vcf_fn}.gz
    fi
done


# Apply SnpEff
for (( chromosome_index=1; chromosome_index<=${number_of_chromosomes}; chromosome_index++ ));
do
    chromosome=`awk "NR==$chromosome_index" ${REF_GENOME_INDEX} | cut -f1`
    filtered_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_filtered_vcfs/filtered.SNP.${chromosome}.vcf.gz"
    snpeff_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.snpeff.SNP.${chromosome}.vcf"
    snpeff_annotated_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.snpeff_annotated.SNP.${chromosome}.vcf"
    annotated_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.annotated.SNP.${chromosome}.vcf"
    if [ ! -s ${snpeff_vcf_fn} ]; then
        ${SNPEFF_EXE} \
            -v -o gatk ${SNPEFF_DB} \
            ${filtered_vcf_fn} \
            -no-downstream \
            -no-upstream \
            -onlyProtein \
            -c ${OPT_DIR}/snpeff/snpEff/snpEff.config \
            -dataDir ${OPT_DIR}/snpeff/snpEff/data/ \
            > ${snpeff_vcf_fn} \
            # 2> /dev/null
    fi
    if [ ! -s ${snpeff_annotated_vcf_fn} ]; then
        ${GATK_EXE} \
            -T VariantAnnotator \
            -R ${REF_GENOME} \
            -A SnpEff \
            --variant ${filtered_vcf_fn} \
            --snpEffFile ${snpeff_vcf_fn} \
            -o ${snpeff_annotated_vcf_fn} \
            2> /dev/null
    fi
    if [ ! -s ${annotated_vcf_fn} ]; then
        cat ${snpeff_annotated_vcf_fn} \
        | ${VCF_ANNOTATE_EXE} -a ${REGIONS_FN} \
           -d key=INFO,ID=RegionType,Number=1,Type=String,Description='The type of genome region within which the variant is found. SubtelomericRepeat: repetitive regions at the ends of the chromosomes. SubtelomericHypervariable: subtelomeric region of poor conservation between the 3D7 reference genome and other samples. InternalHypervariable: chromosome-internal region of poor conservation between the 3D7 reference genome and other samples. Centromere: start and end coordinates of the centromere genome annotation. Core: everything else.' \
           -c CHROM,FROM,TO,INFO/RegionType \
        > ${annotated_vcf_fn}
    fi
    filtered_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/_filtered_vcfs/filtered.INDEL.${chromosome}.vcf.gz"
    snpeff_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.snpeff.INDEL.${chromosome}.vcf"
    snpeff_annotated_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.snpeff_annotated.INDEL.${chromosome}.vcf"
    annotated_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.annotated.INDEL.${chromosome}.vcf"
    if [ ! -s ${snpeff_vcf_fn} ]; then
        ${SNPEFF_EXE} \
            -v -o gatk ${SNPEFF_DB} \
            ${filtered_vcf_fn} \
            -no-downstream \
            -no-upstream \
            -onlyProtein \
            -c ${OPT_DIR}/snpeff/snpEff/snpEff.config \
            -dataDir ${OPT_DIR}/snpeff/snpEff/data/ \
            > ${snpeff_vcf_fn} \
            # 2> /dev/null
    fi
    if [ ! -s ${snpeff_annotated_vcf_fn} ]; then
        ${GATK_EXE} \
            -T VariantAnnotator \
            -R ${REF_GENOME} \
            -A SnpEff \
            --variant ${filtered_vcf_fn} \
            --snpEffFile ${snpeff_vcf_fn} \
            -o ${snpeff_annotated_vcf_fn} \
            2> /dev/null
    fi
    if [ ! -s ${annotated_vcf_fn} ]; then
        cat ${snpeff_annotated_vcf_fn} \
        | ${VCF_ANNOTATE_EXE} -a ${REGIONS_FN} \
           -d key=INFO,ID=RegionType,Number=1,Type=String,Description='The type of genome region within which the variant is found. SubtelomericRepeat: repetitive regions at the ends of the chromosomes. SubtelomericHypervariable: subtelomeric region of poor conservation between the 3D7 reference genome and other samples. InternalHypervariable: chromosome-internal region of poor conservation between the 3D7 reference genome and other samples. Centromere: start and end coordinates of the centromere genome annotation. Core: everything else.' \
           -c CHROM,FROM,TO,INFO/RegionType \
        > ${annotated_vcf_fn}
    fi
done


# Combine SNP and INDEL
for (( chromosome_index=1; chromosome_index<=${number_of_chromosomes}; chromosome_index++ ));
do
    chromosome=`awk "NR==$chromosome_index" ${REF_GENOME_INDEX} | cut -f1`
    annotated_snp_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.annotated.SNP.${chromosome}.vcf"
    annotated_indel_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.annotated.INDEL.${chromosome}.vcf"
    annotated_combined_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.annotated.SNP_INDEL.${chromosome}.vcf"
    if [ ! -s ${annotated_combined_vcf_fn}.gz ]; then
        ${GATK_EXE} \
            -T CombineVariants \
            -R ${REF_GENOME} \
            --variant:snp ${annotated_snp_vcf_fn} \
            --variant:indel ${annotated_indel_vcf_fn} \
            -o ${annotated_combined_vcf_fn} \
            -genotypeMergeOptions PRIORITIZE \
            -priority snp,indel \
            2> /dev/null
        bgzip -f ${annotated_combined_vcf_fn}
        tabix -p vcf -f ${annotated_combined_vcf_fn}.gz
    fi
done


# Apply final filters
for (( chromosome_index=1; chromosome_index<=${number_of_chromosomes}; chromosome_index++ ));
do
    chromosome=`awk "NR==$chromosome_index" ${REF_GENOME_INDEX} | cut -f1`
    annotated_combined_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_intermediate_files/filtered.annotated.SNP_INDEL.${chromosome}.vcf.gz"
    final_vcf_fn="${PROCESSED_DATA_DIR}/${MAPPING_DIR}/${BAMS_DIR}/${UNFILTERED_DIR}/${FILTERED_DIR}/${ANNOTATED_DIR}/_final_vcfs/final.SNP_INDEL.${chromosome}.vcf"
    if [ ! -s ${annotated_combined_vcf_fn}.gz ]; then
        ${GATK_EXE} \
            -T VariantFiltration \
            -R ${REF_GENOME} \
            --variant ${annotated_combined_vcf_fn} \
            -o ${final_vcf_fn} \
            --filterName "Low_VQSLOD" --filterExpression "VQSLOD <= 0.0" \
            --filterName "Centromere" --filterExpression "RegionType == 'Centromere'" \
            --filterName "InternalHypervariable" --filterExpression "RegionType == 'InternalHypervariable'" \
            --filterName "SubtelomericHypervariable" --filterExpression "RegionType == 'SubtelomericHypervariable'" \
            --filterName "SubtelomericRepeat" --filterExpression "RegionType == 'SubtelomericRepeat'" \
            --invalidatePreviousFilters 2> /dev/null
        bgzip -f ${final_vcf_fn}
        tabix -p vcf -f ${final_vcf_fn}.gz
    fi
done

