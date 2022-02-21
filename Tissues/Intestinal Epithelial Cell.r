# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Intestinal Epithelial Cell_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2108600","GSM2108603","GSM2108601","GSM2108612","GSM2108607","GSM2108606","GSM2108614","GSM2108604","GSM2108616","GSM2108611","GSM2108610","GSM2108602","GSM2108615","GSM2108613","GSM2108617","GSM2108609","GSM2108608","GSM2108605","GSM2412774","GSM2412775","GSM2412776","GSM2412773","GSM3418205","GSM3418206","GSM3418207","GSM3418208","GSM3418209","GSM3418210","GSM3418211","GSM3418212","GSM3418213",
"GSM3418214","GSM3418215","GSM3418216","GSM3418217","GSM3418218","GSM3418219","GSM3418220","GSM3418221","GSM3418222","GSM3418223","GSM3418224","GSM3418225","GSM3418226","GSM3418227","GSM3418228","GSM3418229","GSM3418230","GSM3418231","GSM3418232","GSM3418233","GSM3418234","GSM3418235","GSM3418236","GSM3418237","GSM3418238","GSM3418239","")

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

