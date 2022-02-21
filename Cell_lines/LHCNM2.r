# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "LHCNM2_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2068360","GSM2068367","GSM2068361","GSM2068368","GSM2068369","GSM2068359","GSM2072600","GSM2072599","GSM2072534","GSM2072533","GSM4852639","GSM4852640","GSM4852641","GSM4852642","GSM4852643","GSM4852644","GSM4852645","GSM4852646","GSM4852647","GSM4852648","GSM4852649","GSM4852650","GSM4852651","GSM4852652","GSM4852653","GSM5241417","GSM5241418","GSM5241419","GSM5241420","GSM5241421","GSM5241422",
"")

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

