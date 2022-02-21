# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "JEG3_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2102453","GSM2102455","GSM2102456","GSM2102458","GSM2102460","GSM2102457","GSM2102454","GSM2102459","GSM3815114","GSM3815115","GSM4275487","GSM4275488","GSM4275489","GSM4275490","GSM4275491","GSM4275492","GSM4275493","GSM4275494","GSM4275495","GSM4275496","GSM4275497","GSM4275498","")

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

