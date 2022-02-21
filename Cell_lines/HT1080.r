# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "HT1080_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1483943","GSM1483944","GSM1483947","GSM1483945","GSM1483942","GSM1483946","GSM1663104","GSM1663102","GSM1663101","GSM1663103","GSM1663099","GSM1663100","GSM2072494","GSM2072503","GSM2072504","GSM2072493","GSM2071593","GSM2071594","GSM2072552","GSM2072551","GSM1835787","GSM1835788","GSM1835789","GSM1835790","GSM2873884","GSM2873885","GSM2873886","GSM2873887","GSM2304695","GSM2304696","GSM2304697",
"GSM3673610","GSM3673611","GSM3673612","GSM3673613","GSM3673614","GSM3673615","GSM4094816","GSM4094817","GSM4094818","GSM4094819","GSM4094820","GSM4094821","GSM4094822","GSM4094823","GSM4094824","GSM4094825","GSM4094826","GSM4094827","GSM4153696","GSM4153697","GSM4153698","GSM4153699","GSM4153700","GSM4323086","GSM4323087","GSM4323088","GSM4323089","GSM4323090","GSM4323091","GSM4006894",
"GSM4006896","GSM4006897","GSM4006898","GSM4006900","GSM4006901","GSM4006902","GSM4006903","GSM4006904","GSM4006905","GSM4006906","GSM4006907","GSM4006908","")

# Retrieve information from compressed data
samples = h5read(destination_file, "meta/samples/geo_accession")
genes = h5read(destination_file, "meta/genes/genes")

# Identify columns to be extracted
sample_locations = which(samples %in% samp)

# extract gene expression from compressed data
expression = t(h5read(destination_file, "data/expression", index=list(sample_locations, 1:length(genes))))
H5close()
rownames(expression) = genes
colnames(expression) = samples[sample_locations]

# Print file
write.table(expression, file=extracted_expression_file, sep="\t", quote=FALSE, col.names=NA)
print(paste0("Expression file was created at ", getwd(), "/", extracted_expression_file))

